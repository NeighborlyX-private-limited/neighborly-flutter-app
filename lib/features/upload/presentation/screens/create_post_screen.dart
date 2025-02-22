import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_linear_progress_indicator.dart';
import 'package:neighborly_flutter_app/core/utils/video_compresser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/indicator/custom_circular_progress_indicator.dart';
import '../../../../core/widgets/custom_sizedbox.dart';
import '../bloc/upload_post_bloc/upload_post_bloc.dart';
import '../widgets/ban_user_popup.dart';
import '../widgets/post_button_widget.dart';
import '../../../../core/constants/imagepickercompress.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _questionController;
  final List<TextEditingController> _optionControllers = [];

  late FocusNode _titleFocusNode;
  late FocusNode _contentFocusNode;
  final List<FocusNode> _optionFocusNodes = [];

  bool isTitleFilled = false;
  bool isQuestionFilled = false;
  bool allowMultipleVotes = false;
  bool _isButtonActive = true;
  bool _isKeyboardVisible = false;

  late String _condition;

  // Store the selected image
  File? _selectedImage;

  // INIT STATE
  @override
  void initState() {
    super.initState();

    if (isLocationOn()) {
      fetchLocationAndUpdate();
    }
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _questionController = TextEditingController();
    _titleFocusNode = FocusNode();
    _contentFocusNode = FocusNode();
    _condition = 'post';
    _addOption();
    _addOption();
    _titleFocusNode.addListener(_onTiteFocusChange);
    _contentFocusNode.addListener(_onContentFocusChange);
  }

  // DISPOSE
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _questionController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    _videoController?.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    for (var focusNode in _optionFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // CHECK IS USER USING THEIR CURRENT LOCATION OR ANY PERTICULAR LOCATION
  bool isLocationOn() {
    bool isLocationOn = ShardPrefHelper.getCurrent() ?? true;
    if (isLocationOn) {
      return true;
    }
    return false;
  }

  /// handle location
  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      /// location permission denied
      if (permission == LocationPermission.denied) {
        if (mounted) {
          showSnackBar(
            context: context,
            message:
                AppLocalizations.of(context)!.location_permissions_are_denied,
          );
        }
        return false;
      }
    }

    /// location permission forever denied
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: AppLocalizations.of(context)!
              .location_permissions_are_permanently_denied_we_cannot_request_permissions,
        );
      }
      return false;
    }

    /// location permission forever granted
    return true;
  }

  /// fetch the user location and upldate it.
  Future<void> fetchLocationAndUpdate() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: AppLocalizations.of(context)!
              .location_permissions_are_permanently_denied_we_cannot_request_permissions,
        );
      }

      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      ShardPrefHelper.setLocation([position.latitude, position.longitude]);
    } catch (e) {
      if (mounted) {
        showLocationAccessDialog(context);
      }
      if (mounted) {
        showSnackBar(
          context: context,
          message: AppLocalizations.of(context)!.oops_something_went_wrong,
        );
      }
    }
  }

  /// location access dialog
  AlertDialog buildLocationAccessDialog(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: AppColors.whiteColor,
      backgroundColor: AppColors.whiteColor,
      title: Text(AppLocalizations.of(context)!.no_location_access),
      content: Text(
        AppLocalizations.of(context)!
            .device_location_is_turned_off_and_if_you_donot_turn_on_your_location_then_last_location_will_be_used,
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            side: BorderSide(color: AppColors.primaryColor),
            elevation: 0,
            backgroundColor: AppColors.whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }

  /// show location access dialog
  void showLocationAccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildLocationAccessDialog(context);
      },
    );
  }

  void _onTiteFocusChange() {
    setState(() {
      _isKeyboardVisible = _titleFocusNode.hasFocus;
    });
  }

  void _onContentFocusChange() {
    setState(() {
      _isKeyboardVisible = _contentFocusNode.hasFocus;
    });
  }

  /// add option
  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
      _optionFocusNodes.add(FocusNode());
    });
  }

  /// remove option
  void _removeOption(int index) {
    setState(() {
      _optionControllers[index].dispose();
      _optionFocusNodes[index].dispose();
      _optionControllers.removeAt(index);
      _optionFocusNodes.removeAt(index);
    });
  }

  /// check is home
  bool checkIsHome() {
    bool isLocationOn = ShardPrefHelper.getIsLocationOn();
    if (isLocationOn) {
      return true;
    }
    return false;
  }

  /// Function to fetch the current city name
  Future<String?> getCityName() async {
    try {
      /// Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        /// Request permissions if not granted
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return 'Location permissions are denied';
        }
      }

      /// Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      /// Use the coordinates to get the address details
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      /// Extract the city name from the first placemark
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality;
      } else {
        return 'No city found at this location';
      }
    } catch (e) {
      return 'Failed to get city name';
    }
  }

  /// Check if all options and question are filled
  bool checkIsPollActive() {
    if (isQuestionFilled &&
        _optionControllers
            .every((controller) => controller.text.trim().isNotEmpty)) {
      return true;
    }
    return false;
  }

  /// check is active
  bool checkIsActive() {
    if (isTitleFilled) {
      return true;
    }
    return false;
  }

  ///  isImagePicking is true when user start picking a image or video
  bool isImagePicking = false;

  ///  isImageUploading is true when user start uploading a image or video
  bool isImageUploading = false;
  bool isImage = false;
  bool isPollOptionShow = true;
  bool _isPlaying = false;
  File? _thumbnail;
  List<File>? _selectedMedia = [];
  File? _videoFile;
  VideoPlayerController? _videoController;

  /// get thumbnail
  Future<void> _generateVideoThumbnail(String videoPath) async {
    try {
      /// Generate the thumbnail
      Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 400,
        quality: 75,
      );

      if (thumbnail != null) {
        /// Get the directory to store the thumbnail
        final directory = await getApplicationDocumentsDirectory();
        final thumbnailPath = '${directory.path}/thumbnail.jpeg';

        /// Save the thumbnail as a file
        File thumbnailFile = File(thumbnailPath);
        await thumbnailFile.writeAsBytes(thumbnail);

        // Get the path of the saved thumbnail
        String filePath = thumbnailFile.path;

        // Optionally, create a File object and send it to your API
        _thumbnail = File(filePath);

        setState(() {}); // Trigger UI update if necessary
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating thumbnail: $e')),
        );
      }
    }
  }

  /// Pick video from gallery
  Future<void> _pickVideoFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      // Start loading
      setState(() {
        isImagePicking = true;
      });

      // Pick video from gallery
      final XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
      );

      // Check if a video is picked
      if (pickedFile != null) {
        // Get picked video path
        _videoFile = File(pickedFile.path);
        await _generateVideoThumbnail(_videoFile!.path);

        // Calculate video size
        int fileSizeInBytes = _videoFile!.lengthSync();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 50) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      AppLocalizations.of(context)!.this_video_is_too_large)),
            );
          }
          setState(() {
            _videoFile = null;
          });
          return;
        }

        // Compress video
        _videoFile = await compressVideo(_videoFile!);

        // Validate compressed video size
        int compressedFileSizeInBytes = _videoFile!.lengthSync();
        double compressedFileSizeInMB =
            compressedFileSizeInBytes / (1024 * 1024);

        if (compressedFileSizeInMB > 15) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      AppLocalizations.of(context)!.this_video_is_too_large)),
              // SnackBar(content: Text('The video is too large..')),
            );
          }
          setState(() {
            _videoFile = null;
          });

          return;
        }

        // Add compressed video to selected media
        _selectedMedia!.add(_videoFile!);

        // Initialize video controller
        _videoController = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {}); // Refresh the UI after initialization
            _videoController!.pause();
          });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please pick a video')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error in video picking: $e')),
        );
      }
    } finally {
      // Stop loading
      setState(() {
        isImagePicking = false;
        isPollOptionShow = true;
      });
    }
  }

  /// Pick a video from the camera
  Future<void> _pickVideoFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      // Start loading
      setState(() {
        isImagePicking = true;
      });

      // Pick video from camera
      final XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.camera,
      );

      // Check if a video is picked
      if (pickedFile != null) {
        // Get picked video path
        _videoFile = File(pickedFile.path);
        await _generateVideoThumbnail(_videoFile!.path);

        // Calculate initial video size
        int initialFileSizeInBytes = _videoFile!.lengthSync();
        double initialFileSizeInMB = initialFileSizeInBytes / (1024 * 1024);

        // Check if the video size is too large
        if (initialFileSizeInMB > 15) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      AppLocalizations.of(context)!.this_video_is_too_large)),
            );
          }
          setState(() {
            _videoFile = null;
          });

          return;
        }

        // Compress video
        _videoFile = await compressVideo(_videoFile!);

        // Calculate compressed video size
        int compressedFileSizeInBytes = _videoFile!.lengthSync();
        double compressedFileSizeInMB =
            compressedFileSizeInBytes / (1024 * 1024);

        if (compressedFileSizeInMB > 15) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      AppLocalizations.of(context)!.this_video_is_too_large)),
            );
          }
          setState(() {
            _videoFile = null;
          });

          return;
        }

        // Add compressed video to selected media and initialize video controller
        setState(() {
          isPollOptionShow = false;
          _selectedMedia!.add(_videoFile!);

          _videoController = VideoPlayerController.file(_videoFile!)
            ..initialize().then((_) {
              setState(() {});
              _videoController!.pause();
            });
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No video was picked')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error in video picking: $e')),
        );
      }
    } finally {
      // Stop loading
      setState(() {
        isImagePicking = false;
        isPollOptionShow = true;
      });
    }
  }

  /// pic one image or multiple images from gallary
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();

    // Check if the user already has 5 images selected
    if (_selectedMedia!.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.you_can_select_up_to_5_images)),
      );
      setState(() {
        isImage = false;
        _selectedMedia = [];
      });
      return;
    }

    try {
      setState(() {
        isImagePicking = true;
      });

      // Pick multiple images
      List<XFile>? images = await picker.pickMultiImage(
        imageQuality: 95,
        limit: 5,
      );

      if (images.isNotEmpty) {
        for (XFile imageFile in images) {
          // Check if adding this image exceeds the limit
          if (_selectedMedia!.length < 5) {
            XFile compressedImage = await compressImage(imageFileX: imageFile);
            setState(() {
              isImage = true;
              _selectedMedia!.add(
                File(
                  compressedImage.path,
                ),
              ); // Update selected images list
            });
          } else {
            // Show a message if the user tries to select more than 5 images
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!
                      .you_can_select_up_to_5_images)),
              // SnackBar(content: Text('You can select up to 5 images only.')),
            );
            setState(() {
              isImage = false;
              _selectedMedia = [];
            });
            break; // Exit the loop if the limit is reached
          }
        }
        setState(() {
          isImagePicking = false;
        });
        return;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking multiple images: $e')),
        );
      }
    } finally {
      setState(() {
        isImagePicking = false;
      });
    }
  }

  /// pic image  images from camera
  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? image;

    try {
      setState(() {
        isImagePicking = true;
      });

      // Pick image and then compress
      image = await picker.pickImage(source: ImageSource.camera).then((file) {
        return compressImage(imageFileX: file);
      });

      if (image != null) {
        setState(() {
          isImage = true;
          _selectedMedia!.add(File(image!.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    } finally {
      setState(() {
        isImagePicking = false;
      });
    }
  }

  ///remove image
  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  ///remove images from multiple images
  void _removeImages(int index) {
    setState(() {
      _selectedMedia!.removeAt(index);
      if (_selectedMedia!.isEmpty) {
        isImage = false;
      }
    });
  }

  /// is playing video
  void _togglePlayPause() {
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        _isPlaying = false;
      } else {
        _videoController!.play();
        _isPlaying = true;
      }
    });
  }

  /// clear video controller
  void clearVideoController() {
    if (_videoController != null) {
      _videoController!.pause();
      _videoController!.dispose();
      _videoController = null;
    }

    _videoFile = null;
    _selectedMedia!.removeAt(0);

    setState(() {
      isPollOptionShow = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.go('/home');
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isImagePicking ? CustomLinearIndicator() : CustomSizedBox(),
                  isImageUploading ? CustomLinearIndicator() : CustomSizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 14.0,
                      left: 14.0,
                      right: 14.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// close button
                        InkWell(
                          child: const Icon(Icons.close, size: 24),
                          onTap: () {
                            if (_condition == 'post') {
                              isImagePicking = false;
                              isImageUploading = false;
                              isImage = false;
                              _selectedImage = null;
                              _titleController.clear();
                              _contentController.clear();
                              _selectedMedia = [];
                              context.go('/home');
                            } else {
                              setState(() {
                                _condition = 'post';
                              });
                            }
                          },
                        ),
                        _condition == 'post'
                            ? BlocConsumer<UploadPostBloc, UploadPostState>(
                                listener: (context, state) {
                                  /// UploadPostBloc loading state for post
                                  if (state is UploadPostLoadingState) {
                                    setState(() {
                                      isImageUploading = true;
                                    });
                                  }

                                  /// UploadPostBloc failure state for post
                                  if (state is UploadPostFailureState) {
                                    if (state.error
                                        .contains("Sorry, you are banned")) {
                                      isImageUploading = false;
                                      banUserCustomDialog(context);
                                    } else {
                                      isImageUploading = false;
                                      showSnackBar(
                                        context: context,
                                        message: state.error,
                                      );
                                    }
                                  }

                                  /// UploadPostBloc success state for post
                                  else if (state is UploadPostSuccessState) {
                                    setState(() {
                                      isImageUploading = false;
                                    });
                                    _contentController.clear();
                                    _titleController.clear();
                                    _removeImage();
                                    showSnackBar(
                                      context: context,
                                      message: AppLocalizations.of(context)!
                                          .post_created,
                                    );

                                    if (mounted) {
                                      context.go('/home');
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  /// UploadPostBloc loading state for post
                                  if (state is UploadPostLoadingState) {
                                    return CustomCircularIndicator();
                                  }

                                  /// post button
                                  return PostButtonWidget(
                                    onTapListener: () {
                                      if (!_isButtonActive) {
                                        return;
                                      }
                                      setState(() {
                                        _isButtonActive = false;
                                      });

                                      BlocProvider.of<UploadPostBloc>(context)
                                          .add(
                                        UploadPostPressedEvent(
                                          city: 'city',
                                          content:
                                              _contentController.text.trim(),
                                          title: _titleController.text.trim(),
                                          type: 'post',
                                          multimedia: _selectedMedia,
                                          thumbnail: _thumbnail,
                                          allowMultipleVotes: false,
                                          location: [],
                                        ),
                                      );
                                    },
                                    isActive: isTitleFilled,
                                  );
                                },
                              )
                            : BlocConsumer<UploadPostBloc, UploadPostState>(
                                listener: (context, state) {
                                  /// UploadPostBloc failure state for poll
                                  if (state is UploadPostFailureState) {
                                    _questionController.clear();
                                    _removeImage();
                                    showSnackBar(
                                      context: context,
                                      message: state.error,
                                    );
                                  }

                                  /// UploadPostBloc success state for poll
                                  else if (state is UploadPostSuccessState) {
                                    _questionController.clear();
                                    _removeImage();
                                    for (var controller in _optionControllers) {
                                      controller.clear();
                                    }
                                    showSnackBar(
                                      context: context,
                                      message: AppLocalizations.of(context)!
                                          .poll_created,
                                    );
                                    if (mounted) {
                                      context.go('/home');
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  /// UploadPostBloc loading state for poll
                                  if (state is UploadPostLoadingState) {
                                    return CustomCircularIndicator();
                                  }

                                  /// poll button
                                  return PostButtonWidget(
                                    onTapListener: () {
                                      if (!_isButtonActive) {
                                        return;
                                      }
                                      setState(() {
                                        _isButtonActive = false;
                                      });

                                      BlocProvider.of<UploadPostBloc>(context)
                                          .add(
                                        UploadPostPressedEvent(
                                          city: 'city',
                                          multimedia: _selectedMedia,
                                          title:
                                              _questionController.text.trim(),
                                          options: List.generate(
                                            _optionControllers.length,
                                            (index) => {
                                              "option":
                                                  _optionControllers[index]
                                                      .text
                                                      .trim(),
                                            },
                                          ),
                                          type: 'poll',
                                          allowMultipleVotes:
                                              allowMultipleVotes,
                                          location: [],
                                          thumbnail: _thumbnail,
                                        ),
                                      );
                                    },
                                    isActive: checkIsPollActive(),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),

                  /// post text field
                  if (_condition == 'post')
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 14.0,
                        left: 14.0,
                        right: 14.0,
                      ),
                      child: Column(
                        children: [
                          /// post title text field
                          TextField(
                            controller: _titleController,
                            focusNode: _titleFocusNode,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: null,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.title_required,
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                isTitleFilled =
                                    _titleController.text.trim().isNotEmpty;
                              });
                            },
                          ),

                          /// post content text field
                          TextField(
                            controller: _contentController,
                            focusNode: _contentFocusNode,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: null,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .whats_on_your_mind,
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),

                  /// poll text field
                  if (_condition == 'poll')
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 14.0,
                        left: 14.0,
                        right: 14.0,
                      ),
                      child: Column(
                        children: [
                          /// poll question text field
                          TextField(
                            controller: _questionController,
                            focusNode: _contentFocusNode,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: null,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .write_your_question_here,
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                isQuestionFilled =
                                    _questionController.text.trim().isNotEmpty;
                              });
                            },
                          ),
                          const CustomSizedBox(height: 12),

                          /// options text fields
                          ..._buildOptionFields(),

                          /// add option button
                          InkWell(
                            onTap: _addOption,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: AppColors.primaryColor,
                                ),
                                const CustomSizedBox(width: 5),
                                Text(
                                  AppLocalizations.of(context)!.add_option,
                                  style: blueNormalTextStyle,
                                ),
                              ],
                            ),
                          ),
                          const CustomSizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .allow_multiple_votes,
                                style: greyonboardingBody1Style,
                              ),

                              /// allow multiple votes switch button
                              Switch(
                                value: allowMultipleVotes,
                                inactiveThumbColor: AppColors.whiteColor,
                                inactiveTrackColor: AppColors.greyColor,
                                activeTrackColor: AppColors.primaryColor,
                                activeColor: AppColors.whiteColor,
                                onChanged: (value) {
                                  setState(() {
                                    allowMultipleVotes = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  /// video widget
                  if (_videoController != null &&
                      _videoController!.value.isInitialized)
                    CustomSizedBox(
                      height: 10,
                    ),
                  _videoController != null &&
                          _videoController!.value.isInitialized
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 260,
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: VideoPlayer(_videoController!),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    iconSize: 60,
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled,
                                      color: AppColors.whiteColor,
                                    ),
                                    onPressed: _togglePlayPause,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    clearVideoController();
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.greyColor,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: AppColors.lightBackgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _videoController != null
                          ? CustomCircularIndicator()
                          : CustomSizedBox(),
                  if (isImage)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      child: SizedBox(
                        height: 260,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedMedia!.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedMedia![index],
                                    width: double.infinity,
                                    height: 260,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => _removeImages(index),
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.greyColor,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                        color: AppColors.lightBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  const CustomSizedBox(height: 200),
                ],
              ),
            ),
          ),
          bottomSheet: !_isKeyboardVisible
              ? Container(
                  height: 220,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CustomSizedBox(height: 5),
                      InkWell(
                        onTap: _pickImages,
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/add_a_photo.svg'),
                            const CustomSizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!.add_a_photo,
                              style: mediumTextStyleBlack,
                            ),
                          ],
                        ),
                      ),
                      const CustomSizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          _pickImageFromCamera();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromARGB(255, 224, 238, 206),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: const Color.fromARGB(255, 57, 167, 14),
                              ),
                            ),
                            const CustomSizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!.take_a_picture,
                              style: mediumTextStyleBlack,
                            ),
                          ],
                        ),
                      ),
                      const CustomSizedBox(height: 12),
                      _condition == 'poll'
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  _condition = 'post';
                                });
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/create_a_poll.svg'),
                                  const CustomSizedBox(width: 12),
                                  Text(
                                    AppLocalizations.of(context)!.create_a_post,
                                    style: mediumTextStyleBlack,
                                  ),
                                ],
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                _showVideoPickerOptions();
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color.fromARGB(
                                          255, 224, 238, 206),
                                    ),
                                    child: Icon(
                                      Icons.video_chat,
                                      color: const Color.fromARGB(
                                          255, 57, 167, 14),
                                    ),
                                  ),
                                  const CustomSizedBox(width: 12),
                                  Text(
                                    AppLocalizations.of(context)!.add_a_video,
                                    style: mediumTextStyleBlack,
                                  ),
                                ],
                              ),
                            ),
                      const CustomSizedBox(height: 12),
                      _condition == 'post'
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  _condition = 'poll';
                                });
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/create_a_poll.svg'),
                                  const CustomSizedBox(width: 12),
                                  Text(
                                    AppLocalizations.of(context)!.create_a_poll,
                                    style: mediumTextStyleBlack,
                                  ),
                                ],
                              ),
                            )
                          : CustomSizedBox()
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// pic image from gallery option
                      InkWell(
                        onTap: () {
                          _pickImages();
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/add_a_photo.svg'),
                            const CustomSizedBox(width: 10),
                          ],
                        ),
                      ),

                      ///  pic image from camera option
                      InkWell(
                        onTap: () {
                          _pickImageFromCamera();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromARGB(
                                  255,
                                  224,
                                  238,
                                  206,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: const Color.fromARGB(255, 57, 167, 14),
                              ),
                            ),
                            const CustomSizedBox(width: 10),
                          ],
                        ),
                      ),

                      /// video picker option
                      _condition == 'poll'
                          ? CustomSizedBox()
                          : InkWell(
                              onTap: () {
                                _showVideoPickerOptions();
                              },
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color.fromARGB(
                                          255, 224, 238, 206),
                                    ),
                                    child: Icon(
                                      Icons.video_chat,
                                      color: const Color.fromARGB(
                                          255, 57, 167, 14),
                                    ),
                                  ),
                                  const CustomSizedBox(width: 10),
                                ],
                              ),
                            ),

                      /// create poll option
                      _condition == 'post'
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  _condition = 'poll';
                                });
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/create_a_poll.svg',
                                  ),
                                  const CustomSizedBox(width: 10),
                                ],
                              ),
                            )

                          /// create post aption
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  _condition = 'post';
                                });
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/create_a_poll.svg',
                                  ),
                                  const CustomSizedBox(width: 10),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // Build dynamic option fields with the X button for removal
  List<Widget> _buildOptionFields() {
    return List.generate(
      _optionControllers.length,
      (index) {
        _optionFocusNodes[index];

        // Listen to focus changes on each FocusNode
        _optionFocusNodes[index].addListener(() {
          setState(() {
            _isKeyboardVisible = _optionFocusNodes[index].hasFocus;
          });
        });

        return Column(
          children: [
            Stack(
              children: [
                TextField(
                  controller: _optionControllers[index],
                  focusNode: _optionFocusNodes[index],
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText:
                        '${AppLocalizations.of(context)!.option} ${index + 1}',
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                if (index >= 2)
                  Positioned(
                    right: 0,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: AppColors.redColor),
                      onPressed: () {
                        _removeOption(index);
                      },
                    ),
                  ),
              ],
            ),
            const CustomSizedBox(height: 12),
          ],
        );
      },
    );
  }

  void _showVideoPickerOptions() {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.video_library),
                title:
                    Text(AppLocalizations.of(context)!.pick_video_from_gallery),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideoFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: Text(AppLocalizations.of(context)!.record_a_video),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideoFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
