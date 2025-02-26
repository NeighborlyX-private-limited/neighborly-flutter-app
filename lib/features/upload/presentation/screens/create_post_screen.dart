import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool isPollOptionShow = true;
  bool _isButtonActive = true;
  bool _isKeyboardVisible = false;

  VideoPlayerController? _videoController;
  bool isImagePicking = false;
  bool isImageUploading = false;
  bool isImage = false;
  List<File>? _selectedMedia = [];
  bool _isPlaying = false;
  File? _thumbnail;
  File? _videoFile;

  late String _condition;

  // INIT STATE
  @override
  void initState() {
    super.initState();

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

  // ADD POLL OPTIONS
  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
      _optionFocusNodes.add(FocusNode());
    });
  }

  // REMOVE POLL OPTIONS
  void _removeOption(int index) {
    setState(() {
      _optionControllers[index].dispose();
      _optionFocusNodes[index].dispose();
      _optionControllers.removeAt(index);
      _optionFocusNodes.removeAt(index);
    });
  }

  // CHECK IF QUESTIONA AND ALL OPTIONS ARE FILLED
  bool checkIsPollActive() {
    if (isQuestionFilled &&
        _optionControllers
            .every((controller) => controller.text.trim().isNotEmpty)) {
      return true;
    }
    return false;
  }

  // GET THUMBNAIL FROM VIDEO
  Future<void> _generateVideoThumbnail(String videoPath) async {
    try {
      Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 400,
        quality: 75,
      );

      if (thumbnail != null) {
        final directory = await getApplicationDocumentsDirectory();
        final thumbnailPath = '${directory.path}/thumbnail.jpeg';

        File thumbnailFile = File(thumbnailPath);
        await thumbnailFile.writeAsBytes(thumbnail);

        String filePath = thumbnailFile.path;

        _thumbnail = File(filePath);

        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Error while generating thumbnail: $e',
        );
      }
    }
  }

  // PICK A VIDEO FROM GALLERY
  Future<void> _pickVideoFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      setState(() {
        isImagePicking = true;
      });

      final XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
        await _generateVideoThumbnail(_videoFile!.path);

        int fileSizeInBytes = _videoFile!.lengthSync();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 50) {
          if (mounted) {
            showSnackBar(
              context: context,
              message: AppLocalizations.of(context)!.this_video_is_too_large,
            );
          }
          setState(() {
            _videoFile = null;
          });
          return;
        }

        _videoFile = await compressVideo(_videoFile!);

        int compressedFileSizeInBytes = _videoFile!.lengthSync();
        double compressedFileSizeInMB =
            compressedFileSizeInBytes / (1024 * 1024);

        if (compressedFileSizeInMB > 15) {
          if (mounted) {
            showSnackBar(
              context: context,
              message: AppLocalizations.of(context)!.this_video_is_too_large,
            );
          }
          setState(() {
            _videoFile = null;
          });

          return;
        }

        _selectedMedia!.add(_videoFile!);

        _videoController = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {});
            _videoController!.pause();
          });
      } else {
        if (mounted) {
          showSnackBar(
            context: context,
            message: 'Please pick a video',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Error  in video picking: $e',
        );
      }
    } finally {
      setState(() {
        isImagePicking = false;
        isPollOptionShow = true;
      });
    }
  }

  // PICK VIDEO FROM CAMERA
  Future<void> _pickVideoFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      setState(() {
        isImagePicking = true;
      });

      final XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
        await _generateVideoThumbnail(_videoFile!.path);

        int initialFileSizeInBytes = _videoFile!.lengthSync();
        double initialFileSizeInMB = initialFileSizeInBytes / (1024 * 1024);

        if (initialFileSizeInMB > 15) {
          if (mounted) {
            showSnackBar(
              context: context,
              message: AppLocalizations.of(context)!.this_video_is_too_large,
            );
          }
          setState(() {
            _videoFile = null;
          });

          return;
        }

        _videoFile = await compressVideo(_videoFile!);

        int compressedFileSizeInBytes = _videoFile!.lengthSync();
        double compressedFileSizeInMB =
            compressedFileSizeInBytes / (1024 * 1024);

        if (compressedFileSizeInMB > 15) {
          if (mounted) {
            showSnackBar(
              context: context,
              message: AppLocalizations.of(context)!.this_video_is_too_large,
            );
          }
          setState(() {
            _videoFile = null;
          });

          return;
        }

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
          showSnackBar(
            context: context,
            message: 'No video was picked',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Error  in video picking: $e',
        );
      }
    } finally {
      setState(() {
        isImagePicking = false;
        isPollOptionShow = true;
      });
    }
  }

  // TOGGLE PLAY AND PAUSE BUTTON FOR VIDEO
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

  // CLEAR VIDEO CONTROLLER
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

  // PICK IMAGE FROM GALLERY
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();

    // CHECK IF USER ALREADY SELECTED 5 IMAGES
    if (_selectedMedia!.length >= 5) {
      showSnackBar(
        context: context,
        message: AppLocalizations.of(context)!.you_can_select_up_to_5_images,
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

      // PICK ONE OR MULTIPLE IMAGE
      List<XFile>? images = await picker.pickMultiImage(
        imageQuality: 95,
        limit: 5,
      );

      if (images.isNotEmpty) {
        for (XFile imageFile in images) {
          if (_selectedMedia!.length < 5) {
            XFile compressedImage = await compressImage(imageFileX: imageFile);
            setState(() {
              isImage = true;
              _selectedMedia!.add(
                File(
                  compressedImage.path,
                ),
              );
            });
          } else {
            // MORE THAN 5 IMAGE SELECTED
            if (mounted) {
              showSnackBar(
                context: context,
                message:
                    AppLocalizations.of(context)!.you_can_select_up_to_5_images,
              );
            }
            setState(() {
              isImage = false;
              _selectedMedia = [];
            });
            break;
          }
        }
        setState(() {
          isImagePicking = false;
        });
        return;
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Error while picking multiple images: $e',
        );
      }
    } finally {
      setState(() {
        isImagePicking = false;
      });
    }
  }

  // PICK IMAGE FROM CAMERA
  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? image;

    try {
      setState(() {
        isImagePicking = true;
      });

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
        showSnackBar(
          context: context,
          message: 'Error while picking image: $e',
        );
      }
    } finally {
      setState(() {
        isImagePicking = false;
      });
    }
  }

  // REMOVE IMAGE IF MULTIPLE IMAGE IS SELECTED
  void _removeImages(int index) {
    setState(() {
      _selectedMedia!.removeAt(index);
      if (_selectedMedia!.isEmpty) {
        isImage = false;
      }
    });
  }

// BUILD
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.go('/home');
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.lightBackgroundColor,
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
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // CLOSE BUTTON
                        InkWell(
                          child: const Icon(Icons.close, size: 24),
                          onTap: () {
                            if (_condition == 'post') {
                              _titleController.clear();
                              _contentController.clear();
                              _selectedMedia = [];
                              isImagePicking = false;
                              isImageUploading = false;
                              isImage = false;
                              context.go('/home');
                            } else {
                              setState(() {
                                _condition = 'post';
                              });
                            }
                          },
                        ),
                        // POST BUTTON
                        _condition == 'post'
                            ? BlocConsumer<UploadPostBloc, UploadPostState>(
                                listener: (context, state) {
                                  // FAILURE STATE
                                  if (state is UploadPostFailureState) {
                                    if (state.error
                                        .contains("Sorry, you are banned")) {
                                      _contentController.clear();
                                      _titleController.clear();
                                      _selectedMedia = [];
                                      banUserCustomDialog(context);
                                    } else {
                                      showSnackBar(
                                        context: context,
                                        message: state.error,
                                      );
                                    }
                                  }

                                  // SUCCESS STATE
                                  else if (state is UploadPostSuccessState) {
                                    _contentController.clear();
                                    _titleController.clear();
                                    _selectedMedia = [];

                                    if (mounted) {
                                      context.go('/home');
                                    }
                                    showSnackBar(
                                      context: context,
                                      message: AppLocalizations.of(context)!
                                          .post_created,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  // LOADING STATE
                                  if (state is UploadPostLoadingState) {
                                    return CustomCircularIndicator();
                                  }

                                  // POST BUTTON
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
                                          type: 'post',
                                          title: _titleController.text.trim(),
                                          content:
                                              _contentController.text.trim(),
                                          allowMultipleVotes: false,
                                          multimedia: _selectedMedia,
                                          thumbnail: _thumbnail,
                                          location: [],
                                          city: 'city',
                                        ),
                                      );
                                    },
                                    isActive: isTitleFilled,
                                  );
                                },
                              )
                            // POLL BUTTON
                            : BlocConsumer<UploadPostBloc, UploadPostState>(
                                listener: (context, state) {
                                  // FAILURE STATE
                                  if (state is UploadPostFailureState) {
                                    if (state.error
                                        .contains("Sorry, you are banned")) {
                                      _questionController.clear();
                                      for (var controller
                                          in _optionControllers) {
                                        controller.clear();
                                      }
                                      banUserCustomDialog(context);
                                    } else {
                                      showSnackBar(
                                        context: context,
                                        message: state.error,
                                      );
                                    }
                                  }

                                  // SUCCESS STATE
                                  else if (state is UploadPostSuccessState) {
                                    _questionController.clear();
                                    for (var controller in _optionControllers) {
                                      controller.clear();
                                    }
                                    if (mounted) {
                                      context.go('/home');
                                    }
                                    showSnackBar(
                                      context: context,
                                      message: AppLocalizations.of(context)!
                                          .poll_created,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  // LOADING STATE
                                  if (state is UploadPostLoadingState) {
                                    return CustomCircularIndicator();
                                  }

                                  // POLL BUTTON
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
                                          type: 'poll',
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
                                          allowMultipleVotes:
                                              allowMultipleVotes,
                                          multimedia: _selectedMedia,
                                          thumbnail: _thumbnail,
                                          location: [],
                                          city: 'city',
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

                  // POST TEXT FIELD
                  if (_condition == 'post')
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 14.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Column(
                        children: [
                          // POST TITLE TEXT FIELD
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

                          // POST CONTENT TEXT FIELD
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
                              setState(() {
                                // WE DO THIS FOR BUTTON ACTIVE
                                // isTitleFilled =
                                //     _titleController.text.trim().isNotEmpty;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                  // POLL TEXT FIELDS
                  if (_condition == 'poll')
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 14.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Column(
                        children: [
                          // POLL QUESTION TEXT FIELD
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

                          // POLL OPTION TEXT FIELDS
                          ..._buildOptionFields(),

                          // ADD NEW POLL OPTION TEXT FIELD BUTTON
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

                              // ALLOW MULTIPLE VOTE SWITCH BUTTON
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

                  // SHOW VIDEO WIDHET
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
                        horizontal: 16,
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
                    horizontal: 16,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CustomSizedBox(height: 5),
                      // PICK IMAGE FROM GALLERY
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
                      // PICK IMAGE FROM CAMERA
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
                          // CREATE A POST OPTION
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
                          // PICK VIDEO OPTION
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
                                        255,
                                        224,
                                        238,
                                        206,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.video_chat,
                                      color: const Color.fromARGB(
                                        255,
                                        57,
                                        167,
                                        14,
                                      ),
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
                      // CREATE A POLL OPTION
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
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // PICK IMAGE FROM GALLERY
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

                      // PICK IMAGE FROM CAMERA
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

                      // PICK VIDEO OPTION
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
                                        255,
                                        224,
                                        238,
                                        206,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.video_chat,
                                      color: const Color.fromARGB(
                                        255,
                                        57,
                                        167,
                                        14,
                                      ),
                                    ),
                                  ),
                                  const CustomSizedBox(width: 10),
                                ],
                              ),
                            ),

                      // CREATE A POLL OPTION
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

                          // CREATE A POST OPTION
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

  // BUILD DYNAMIC OPTION TEXT FIELDS WITH REMOVE BUTTON
  List<Widget> _buildOptionFields() {
    return List.generate(
      _optionControllers.length,
      (index) {
        _optionFocusNodes[index];

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

  // PICK VIDEO OPTION BOTTOM SHEET
  void _showVideoPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
