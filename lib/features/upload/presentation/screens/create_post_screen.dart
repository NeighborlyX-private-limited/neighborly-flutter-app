import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../bloc/upload_post_bloc/upload_post_bloc.dart';
import '../widgets/post_button_widget.dart';
import '../../../../core/constants/imagepickercompress.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late TextEditingController _contentController;
  late TextEditingController _titleController;
  late TextEditingController _questionController;

  // List of option controllers and focus nodes
  final List<TextEditingController> _optionControllers = [];
  final List<FocusNode> _optionFocusNodes = [];

  bool isTitleFilled = false;
  bool isQuestionFilled = false;
  bool allowMultipleVotes = false;

  late String _condition;

  late FocusNode _titleFocusNode; // Declare the FocusNode
  late FocusNode _contentFocusNode;
  bool _isKeyboardVisible = false; // Track keyboard visibility

  File? _selectedImage; // Store the selected image

  @override
  void initState() {
    _contentController = TextEditingController();
    _titleController = TextEditingController();
    _questionController = TextEditingController();
    _condition = 'post';
    super.initState();
    _addOption(); // Add two default options
    _addOption();

    _titleFocusNode = FocusNode(); // Initialize FocusNode
    _contentFocusNode = FocusNode();

    _titleFocusNode.addListener(_onTiteFocusChange);
    _contentFocusNode.addListener(_onContentFocusChange);
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

  bool checkIsActive() {
    if (isTitleFilled) {
      return true;
    }
    return false;
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
      _optionFocusNodes.add(FocusNode());
    });
  }

  void _removeOption(int index) {
    setState(() {
      _optionControllers[index].dispose();
      _optionFocusNodes[index].dispose();
      _optionControllers.removeAt(index);
      _optionFocusNodes.removeAt(index);
    });
  }

  @override
  void dispose() {
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

  // void _onOptionFocusChange(int index) {
  //   setState(() {
  //     _isKeyboardVisible = _optionFocusNodes[index].hasFocus;
  //   });
  // }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery).then((file){
      return compressImage(imageFileX: file);
    });

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: GestureDetector(
            onTap: () {
              // Close the keyboard when tapping outside of the input field
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 14.0, left: 14.0, right: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: const Icon(Icons.close, size: 30),
                          onTap: () {
                            if (_condition == 'post') {
                              _titleController.clear();
                              _contentController.clear();
                              _selectedImage = null; // Clear selected image

                              context.go('/home/false');
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
                                  if (state is UploadPostFailureState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.error)),
                                    );
                                  } else if (state is UploadPostSuccessState) {
                                    _contentController.clear();
                                    _titleController.clear();
                                    _removeImage();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Post Created'),
                                      ),
                                    );

                                    context.go('/home/false');
                                  }
                                },
                                builder: (context, state) {
                                  if (state is UploadPostLoadingState) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return PostButtonWidget(
                                    onTapListener: () async {
                                      List<double> location =
                                          ShardPrefHelper.getLocation();

                                      List<Placemark> placemarks =
                                          await placemarkFromCoordinates(
                                        location[0],
                                        location[1],
                                      );
                                      BlocProvider.of<UploadPostBloc>(context)
                                          .add(
                                        UploadPostPressedEvent(
                                          city: placemarks[0].locality ?? '',
                                          content:
                                              _contentController.text.trim(),
                                          title: _titleController.text.trim(),
                                          type: 'post',
                                          multimedia: _selectedImage,
                                          allowMultipleVotes: false,
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
                                    context.go('/home/false');
                                  }
                                },
                                builder: (context, state) {
                                  if (state is UploadPostLoadingState) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return PostButtonWidget(
                                    onTapListener: () async {
                                      List<double> location =
                                          ShardPrefHelper.getLocation();

                                      List<Placemark> placemarks =
                                          await placemarkFromCoordinates(
                                        location[0],
                                        location[1],
                                      );

                                      BlocProvider.of<UploadPostBloc>(context)
                                          .add(
                                        UploadPostPressedEvent(
                                          city: placemarks[0].locality ?? '',
                                          multimedia: _selectedImage,
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
                  if (_selectedImage != null) // Preview selected image
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: 260,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_condition == 'post')
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 14.0, left: 14.0, right: 14.0),
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                isTitleFilled =
                                    _titleController.text.trim().isNotEmpty;
                              });
                            },
                            controller: _titleController,
                            focusNode: _titleFocusNode, // Attach the FocusNode
                            decoration: const InputDecoration(
                              hintText: 'Title',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                // Handle content input changes if necessary
                              });
                            },
                            controller: _contentController,
                            focusNode:
                                _contentFocusNode, // Attach the FocusNode
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
                            onChanged: (value) {
                              setState(() {
                                isQuestionFilled =
                                    _questionController.text.trim().isNotEmpty;
                              });
                            },
                            controller: _questionController,

                            focusNode:
                                _contentFocusNode, // Attach the FocusNode
                            decoration: const InputDecoration(
                              hintText: 'Write your question here...',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                          ),
                          const SizedBox(height: 12),
                          ..._buildOptionFields(), // Build option fields
                          InkWell(
                            onTap: _addOption,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Color(0xff635BFF),
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
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey,
                                activeTrackColor: const Color(0xff635BFF),
                                activeColor: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                      height: 200), // Space to accommodate the bottom sheet
                ],
              ),
            ),
          ),
          bottomSheet: !_isKeyboardVisible
              ? Container(
                  color: Colors.white,
                  height: 220,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: _pickImage,
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/add_a_photo.svg'),
                            const SizedBox(width: 10),
                            Text('Add a Photo or GIF',
                                style: mediumTextStyleBlack),
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
                      InkWell(
                        onTap: () {
                          setState(() {
                            _condition = 'poll';
                          });
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/create_a_poll.svg'),
                            const SizedBox(width: 10),
                            Text('Create a Poll', style: mediumTextStyleBlack),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          _pickImage();
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/add_a_photo.svg'),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     SvgPicture.asset('assets/communities.svg'),
                      //     const SizedBox(width: 10),
                      //   ],
                      // ),
                      Row(
                        children: [
                          SvgPicture.asset('assets/add_location.svg'),
                          const SizedBox(width: 10),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     SvgPicture.asset('assets/create_an_event.svg'),
                      //     const SizedBox(width: 10),
                      //   ],
                      // ),
                      InkWell(
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
                      ),
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
                onChanged: (value) {
                  setState(() {
                    // Option filled check is performed on all options
                  });
                },
                controller: _optionControllers[index],
                focusNode: _optionFocusNodes[index], // Attach the FocusNode
                decoration: InputDecoration(
                  labelText: 'Option ${index + 1}',
                  border: const OutlineInputBorder(),
                ),
              ),
              if (index >=
                  2) // Adding the X button for options after the first two
                Positioned(
                  right: 0,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
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
}
