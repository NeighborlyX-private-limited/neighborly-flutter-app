import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/video_compresser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/bouncing_logo_indicator.dart';
import '../bloc/upload_post_bloc/upload_post_bloc.dart';
import '../widgets/post_button_widget.dart';
import '../../../../core/constants/imagepickercompress.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  /// text editing controllers
  late TextEditingController _contentController;
  late TextEditingController _titleController;
  late TextEditingController _questionController;

  // List of option controllers and focus nodes
  final List<TextEditingController> _optionControllers = [];
  final List<FocusNode> _optionFocusNodes = [];

  bool isTitleFilled = false;
  bool isQuestionFilled = false;
  bool allowMultipleVotes = false;
  bool _isButtonActive = true;

  late String _condition;
  late FocusNode _titleFocusNode;
  late FocusNode _contentFocusNode;
  bool _isKeyboardVisible = false;

  // Store the selected image
  File? _selectedImage;

  /// initstate
  @override
  void initState() {
    super.initState();
    if (isLocationOn()) {
      fetchLocationAndUpdate();
    }
    _contentController = TextEditingController();
    _titleController = TextEditingController();
    _questionController = TextEditingController();
    _condition = 'post';
    _addOption();
    _addOption();

    _titleFocusNode = FocusNode();
    _contentFocusNode = FocusNode();

    _titleFocusNode.addListener(_onTiteFocusChange);
    _contentFocusNode.addListener(_onContentFocusChange);
  }

  /// dispose
  @override
  void dispose() {
    super.dispose();
    _videoController?.dispose();
    _contentController.dispose();
    _titleController.dispose();
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    for (var focusNode in _optionFocusNodes) {
      focusNode.dispose();
    }
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
  }

  /// is location on
  bool isLocationOn() {
    bool isLocationOn = ShardPrefHelper.getIsLocationOn();
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
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are denied.'),
            ),
          );
        }
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.'),
          ),
        );
      }
      return false;
    }
    return true;
  }

  /// fetch the user location and upldate it.
  Future<void> fetchLocationAndUpdate() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.'),
          ),
        );
      }

      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      ShardPrefHelper.setLocation([position.latitude, position.longitude]);
      print(
          'Lat Long in create post Screen: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      if (mounted) {
        showLocationAccessDialog(context);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
      debugPrint('Error getting location in create post: $e');
    }
  }

  /// location access dialog
  AlertDialog buildLocationAccessDialog(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: AppColors.whiteColor,
      backgroundColor: AppColors.whiteColor,
      title: Text("No Location Access"),
      content: Text(
          "Device location is turned off, and if you don't turn on your location then last location will be used."),
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
          child: Text("OK"),
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
      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Request permissions if not granted
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return 'Location permissions are denied';
        }
      }

      // Get the current position (latitude and longitude)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Use the coordinates to get the address details
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Extract the city name from the first placemark
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality;
      } else {
        return 'No city found at this location';
      }
    } catch (e) {
      print('Error getting city name in getCityName: $e');
      return 'Failed to get city name';
    }
  }

  // Check if all options and question are filled
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

  /// image and video picking variables
  bool isImagePicking = false;
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
      // Generate the thumbnail
      Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 400,
        quality: 75,
      );

      if (thumbnail != null) {
        // Get the directory to store the thumbnail
        final directory = await getApplicationDocumentsDirectory();
        final thumbnailPath = '${directory.path}/thumbnail.jpeg';

        // Save the thumbnail as a file
        File thumbnailFile = File(thumbnailPath);
        await thumbnailFile.writeAsBytes(thumbnail);

        // Get the path of the saved thumbnail
        String filePath = thumbnailFile.path;

        // Now you can send the file as part of your API request
        print('Thumbnail saved at: $filePath');

        // Optionally, create a File object and send it to your API
        _thumbnail = File(filePath);
        // Pass this `thumbnailForApi` to your API method as required

        setState(() {}); // Trigger UI update if necessary
      }
    } catch (e) {
      print('Error generating thumbnail: $e');
    }
  }

  // Future<void> _generateVideoThumbnail(String videoPath) async {
  //   try {
  //     Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
  //       video: videoPath,
  //       imageFormat: ImageFormat.JPEG,
  //       maxWidth: 400,
  //       quality: 75,
  //     );

  //     if (thumbnail != null) {
  //       String base64Thumbnail = base64Encode(thumbnail);
  //       print('Base64 Encoded Thumbnail: $base64Thumbnail');
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     print('Error generating thumbnail: $e');
  //   }
  // }

  // Pick video from gallery
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
        print('Video size before: ${fileSizeInMB.toStringAsFixed(2)} MB');

        if (fileSizeInMB > 50) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('The video is too large..')),
            );
          }
          setState(() {
            _videoFile = null;
          });
          print('The video is too large.');
          return;
        }

        // Compress video
        _videoFile = await compressVideo(_videoFile!);

        // Validate compressed video size
        int compressedFileSizeInBytes = _videoFile!.lengthSync();
        double compressedFileSizeInMB =
            compressedFileSizeInBytes / (1024 * 1024);
        print(
            'Video size after: ${compressedFileSizeInMB.toStringAsFixed(2)} MB');

        if (compressedFileSizeInMB > 15) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('The video is too large..')),
            );
          }
          setState(() {
            _videoFile = null;
          });
          print('The video is too large after compression.');
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
        print('Please pick a video.');
      }
    } catch (e) {
      print('Error in video picking: $e');
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
        print(
            'Initial file size: ${initialFileSizeInMB.toStringAsFixed(2)} MB');

        // Check if the video size is too large
        if (initialFileSizeInMB > 15) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('The video is too large..')),
            );
          }
          setState(() {
            _videoFile = null;
          });
          print('The video is too large.');
          return;
        }
        //      if (_selectedMedia!.length >= 5) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('You can select up to 5 images.')),
        //   );
        //   setState(() {
        //     isImage = false;
        //     _selectedMedia = [];
        //   });
        //   return;
        // }

        // Compress video
        _videoFile = await compressVideo(_videoFile!);

        // Calculate compressed video size
        int compressedFileSizeInBytes = _videoFile!.lengthSync();
        double compressedFileSizeInMB =
            compressedFileSizeInBytes / (1024 * 1024);
        print(
            'Compressed video size: ${compressedFileSizeInMB.toStringAsFixed(2)} MB');

        if (compressedFileSizeInMB > 15) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('The video is too large..')),
            );
          }
          setState(() {
            _videoFile = null;
          });
          print('The compressed video is still too large.');
          return;
        }

        // Add compressed video to selected media and initialize video controller
        setState(() {
          isPollOptionShow = false;
          _selectedMedia!.add(_videoFile!);

          _videoController = VideoPlayerController.file(_videoFile!)
            ..initialize().then((_) {
              setState(() {}); // Refresh UI after initialization
              _videoController!.pause();
            });
        });
      } else {
        print('No video was picked.');
      }
    } catch (e) {
      print('Error in video picking: $e');
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
        SnackBar(content: Text('You can select up to 5 images.')),
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
            print(_selectedMedia);
          } else {
            // Show a message if the user tries to select more than 5 images
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You can select up to 5 images only.')),
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
      print("Error picking multiple images: $e");
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
      print("Error picking image: $e");
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

    print('Video and controller cleared.');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isImagePicking ? LinearProgressIndicator() : SizedBox(),
                  isImageUploading ? LinearProgressIndicator() : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 14.0,
                      left: 14.0,
                      right: 14.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: const Icon(Icons.close, size: 30),
                          onTap: () {
                            print(
                                '_selectedImage path in on tap fn: $_selectedImage');
                            if (_condition == 'post') {
                              isImageUploading = false;
                              _titleController.clear();
                              _contentController.clear();
                              _selectedMedia = [];
                              isImage = false;
                              _selectedImage = null;
                              context.go('/home/Home');
                              // context.go('/MainPage');
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
                                  if (state is UploadPostLoadingState) {
                                    setState(() {
                                      isImageUploading = true;
                                    });
                                  }
                                  if (state is UploadPostFailureState) {
                                    ///chnage error msg error

                                    if (state.error
                                        .contains("Sorry, you are banned")) {
                                      isImageUploading = false;
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  // Placeholder for the image
                                                  SvgPicture.asset(
                                                    'assets/something_went_wrong.svg',
                                                    width: 150,
                                                    height: 130,
                                                  ),
                                                  const SizedBox(height: 20),
                                                  const Text(
                                                    'Aaah! Something went wrong',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Text(
                                                    "Sorry,You are banned.\nPlease try it after some time",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.greyColor,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 20),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: AppColors
                                                          .primaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 10),
                                                      child: Text(
                                                        'Go Back',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: AppColors
                                                                .whiteColor),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(
                                      //   SnackBar(
                                      //     content:
                                      //         Text("Sorry, you are banned"),
                                      //   ),
                                      // );
                                    } else {
                                      isImageUploading = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(state.error)),
                                      );
                                    }
                                  } else if (state is UploadPostSuccessState) {
                                    setState(() {
                                      isImageUploading = false;
                                    });
                                    _contentController.clear();
                                    _titleController.clear();
                                    _removeImage();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Post Created'),
                                      ),
                                    );

                                    context.go('/home/Home');
                                  }
                                },
                                builder: (context, state) {
                                  if (state is UploadPostLoadingState) {
                                    return const Center(
                                        child: Text('Uploading...'));
                                  }
                                  return PostButtonWidget(
                                    onTapListener: () async {
                                      if (!_isButtonActive) {
                                        return; // Prevent multiple taps
                                      }
                                      setState(() {
                                        _isButtonActive =
                                            false; // Disable the button
                                      });

                                      await fetchLocationAndUpdate();
                                      bool iaLocationOn =
                                          ShardPrefHelper.getIsLocationOn();

                                      List<double> location =
                                          ShardPrefHelper.getLocation();

                                      List<double> homeLocation =
                                          ShardPrefHelper.getHomeLocation();

                                      String city = '';
                                      List<double> locationCord = [];
                                      if (iaLocationOn) {
                                        List<Placemark> placemarks =
                                            await placemarkFromCoordinates(
                                          location[0],
                                          location[1],
                                        );
                                        var lat = location[0];
                                        var long = location[1];
                                        locationCord.add(lat);
                                        locationCord.add(long);
                                        city = placemarks[0].locality ?? '';
                                      } else {
                                        List<Placemark> placemarks =
                                            await placemarkFromCoordinates(
                                          homeLocation[0],
                                          homeLocation[1],
                                        );
                                        var lat = homeLocation[0];
                                        var long = homeLocation[1];
                                        locationCord.add(lat);
                                        locationCord.add(long);
                                        city = placemarks[0].locality ?? '';
                                      }

                                      print("...post city:$city");
                                      print("...post city cord:$locationCord");
                                      print('selectedImage: $_selectedImage');
                                      BlocProvider.of<UploadPostBloc>(context)
                                          .add(
                                        UploadPostPressedEvent(
                                          city: city,
                                          content:
                                              _contentController.text.trim(),
                                          title: _titleController.text.trim(),
                                          type: 'post',
                                          multimedia: _selectedMedia,
                                          thumbnail: _thumbnail,
                                          allowMultipleVotes: false,
                                          location: locationCord,
                                        ),
                                      );
                                    },
                                    isActive: isTitleFilled,
                                  );
                                },
                              )
                            : BlocConsumer<UploadPostBloc, UploadPostState>(
                                listener: (context, state) {
                                  if (state is UploadPostFailureState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.error)),
                                    );
                                  } else if (state is UploadPostSuccessState) {
                                    _questionController.clear();

                                    _removeImage();
                                    for (var controller in _optionControllers) {
                                      controller.clear();
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Poll Created'),
                                      ),
                                    );
                                    context.go('/home/Home');
                                  }
                                },
                                builder: (context, state) {
                                  if (state is UploadPostLoadingState) {
                                    return Center(
                                      child: BouncingLogoIndicator(
                                        logo: 'images/logo.svg',
                                      ),
                                    );
                                    // return const Center(
                                    //   child: CircularProgressIndicator(),
                                    // );
                                  }
                                  return PostButtonWidget(
                                    onTapListener: () async {
                                      if (!_isButtonActive) {
                                        return; // Prevent multiple taps
                                      }
                                      setState(() {
                                        _isButtonActive =
                                            false; // Disable the button
                                      });
                                      bool iaLocationOn =
                                          ShardPrefHelper.getIsLocationOn();

                                      List<double> location =
                                          ShardPrefHelper.getLocation();

                                      List<double> homeLocation =
                                          ShardPrefHelper.getHomeLocation();

                                      String city = '';
                                      List<double> locationCord = [];
                                      if (iaLocationOn) {
                                        List<Placemark> placemarks =
                                            await placemarkFromCoordinates(
                                          location[0],
                                          location[1],
                                        );
                                        var lat = location[0];
                                        var long = location[1];
                                        locationCord.add(lat);
                                        locationCord.add(long);
                                        city = placemarks[0].locality ?? '';
                                      } else {
                                        List<Placemark> placemarks =
                                            await placemarkFromCoordinates(
                                          homeLocation[0],
                                          homeLocation[1],
                                        );
                                        var lat = homeLocation[0];
                                        var long = homeLocation[1];
                                        locationCord.add(lat);
                                        locationCord.add(long);
                                        city = placemarks[0].locality ?? '';
                                      }

                                      print("city during post:$city");
                                      print("cord during post :$locationCord");
                                      BlocProvider.of<UploadPostBloc>(context)
                                          .add(
                                        UploadPostPressedEvent(
                                          city: city,
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
                                          location: locationCord,
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

                  if (_videoController != null &&
                      _videoController!.value.isInitialized)
                    SizedBox(
                      height: 10,
                    ),
                  // (_videoController != null &&
                  //         _videoController!.value.isInitialized)?
                  (_videoController != null &&
                          _videoController!.value.isInitialized)
                      ? Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 260,
                              // color: Colors.redAccent,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: VideoPlayer(_videoController!),
                                ),
                              ),
                              // child: Center(
                              //   child: Transform.rotate(
                              //     angle: pi / 2,
                              //     child: AspectRatio(
                              //       aspectRatio: 1 / 1,
                              //       child: VideoPlayer(_videoController!),
                              //     ),
                              //   ),
                              // ),
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
                                  // here i have write the code clear the controller
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.redColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: AppColors.whiteColor,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : _videoController != null
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          : SizedBox(),
                  if (isImage)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 260,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedMedia!.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
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
                                      decoration: const BoxDecoration(
                                        color: AppColors.redColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: AppColors.whiteColor,
                                        size: 24,
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
                  if (_condition == 'post')
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 14.0,
                        left: 14.0,
                        right: 14.0,
                      ),
                      child: Column(
                        children: [
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {
                              setState(() {
                                isTitleFilled =
                                    _titleController.text.trim().isNotEmpty;
                              });
                            },
                            controller: _titleController,
                            focusNode: _titleFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'Title (Required)',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                          ),
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {
                              setState(() {
                                // Handle content input changes if necessary
                              });
                            },
                            controller: _contentController,
                            focusNode: _contentFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'What\'s on your mind?',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                          ),
                        ],
                      ),
                    ),
                  if (_condition == 'poll')
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 14.0, left: 14.0, right: 14.0),
                      child: Column(
                        children: [
                          TextField(
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (value) {
                              setState(() {
                                isQuestionFilled =
                                    _questionController.text.trim().isNotEmpty;
                              });
                            },
                            controller: _questionController,
                            focusNode: _contentFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'Write your question here...',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                          ),
                          const SizedBox(height: 12),
                          ..._buildOptionFields(),
                          InkWell(
                            onTap: _addOption,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Add Option',
                                  style: blueNormalTextStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Allow multiple votes',
                                style: greyonboardingBody1Style,
                              ),
                              Switch(
                                value: allowMultipleVotes,
                                onChanged: (value) {
                                  setState(() {
                                    allowMultipleVotes = value;
                                  });
                                },
                                inactiveThumbColor: AppColors.whiteColor,
                                inactiveTrackColor: AppColors.greyColor,
                                activeTrackColor: AppColors.primaryColor,
                                activeColor: AppColors.whiteColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
          bottomSheet: !_isKeyboardVisible
              ? Container(
                  color: AppColors.whiteColor,
                  height: 220,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: _pickImages,
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/add_a_photo.svg'),
                            const SizedBox(width: 10),
                            Text(
                              'Add a Photo',
                              style: mediumTextStyleBlack,
                            ),
                          ],
                        ),
                      ),
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
                            const SizedBox(width: 10),
                            Text('Take a Picture', style: mediumTextStyleBlack)
                          ],
                        ),
                      ),
                      _condition == 'poll'
                          ? SizedBox()
                          : InkWell(
                              onTap: () {
                                _showVideoPickerOptions();
                                // _pickImageFromCamera();
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
                                  const SizedBox(width: 10),
                                  Text('Add a video',
                                      style: mediumTextStyleBlack)
                                ],
                              ),
                            ),
                      // InkWell(
                      //   onTap: () {
                      //     context.push('/groups/create');
                      //   },
                      //   child: Row(
                      //     children: [
                      //       SvgPicture.asset('assets/communities.svg'),
                      //       const SizedBox(width: 10),
                      //       Text('Create Community',
                      //           style: mediumTextStyleBlack),
                      //     ],
                      //   ),
                      // ),

                      // TODO: create a action to this and remove the comment

                      // Row(
                      //   children: [
                      //     SvgPicture.asset('assets/add_location.svg'),
                      //     const SizedBox(width: 10),
                      //     Text('Add Location', style: mediumTextStyleBlack),
                      //   ],
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     context.push('/events/create');
                      //   },
                      //   child: Row(
                      //     children: [
                      //       SvgPicture.asset('assets/create_an_event.svg'),
                      //       const SizedBox(width: 10),
                      //       Text('Create an Event',
                      //           style: mediumTextStyleBlack),
                      //     ],
                      //   ),
                      // ),
                      isPollOptionShow
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  _condition = 'poll';
                                });
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/create_a_poll.svg'),
                                  const SizedBox(width: 10),
                                  Text('Create a Poll',
                                      style: mediumTextStyleBlack),
                                ],
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                )
              : Container(
                  color: AppColors.whiteColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          _pickImages();
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/add_a_photo.svg'),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
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
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      _condition == 'poll'
                          ? SizedBox()
                          : InkWell(
                              onTap: () {
                                _showVideoPickerOptions();
                                // _pickImageFromCamera();
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
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                      isPollOptionShow
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  _condition = 'poll';
                                });
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/create_a_poll.svg'),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                )),
    );
  }

  // Build dynamic option fields with the X button for removal
  List<Widget> _buildOptionFields() {
    return List.generate(_optionControllers.length, (index) {
      // _optionFocusNodes[index] ??= FocusNode();
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
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  setState(() {
                    // Option filled check is performed on all options
                  });
                },
                controller: _optionControllers[index],
                focusNode: _optionFocusNodes[index],
                decoration: InputDecoration(
                  labelText: 'Option ${index + 1}',
                  border: const OutlineInputBorder(),
                ),
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
          const SizedBox(height: 12),
        ],
      );
    });
  }

  void _showVideoPickerOptions() {
    showModalBottomSheet(
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
                title: const Text("Pick Video from Gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideoFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text("Record a Video"),
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
