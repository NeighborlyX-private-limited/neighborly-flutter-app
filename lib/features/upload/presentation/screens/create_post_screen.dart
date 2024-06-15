import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/upload_post_bloc/upload_post_bloc.dart';
import '../widgets/post_button_widget.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late TextEditingController _contentController;
  late TextEditingController _titleController;
  late TextEditingController _quesitonController;
  late TextEditingController _option1Controller;
  late TextEditingController _option2Controller;

  late bool isActive = false;
  late String _condition;

  @override
  void initState() {
    _contentController = TextEditingController();
    _titleController = TextEditingController();
    _quesitonController = TextEditingController();
    _option1Controller = TextEditingController();
    _option2Controller = TextEditingController();
    _condition = 'post';
    super.initState();
  }

  bool checkIsActive() {
    if (isActive) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    _contentController.dispose();
    _titleController.dispose();
    _quesitonController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 14.0, left: 14.0, right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: const Icon(
                          Icons.close,
                          size: 20,
                        ),
                        onTap: () {
                          if (_condition == 'post') {
                            _titleController.clear();
                            _contentController.clear();
                          } else {
                            setState(() {
                              _condition = 'post';
                            });
                          }
                        },
                      ),
                      BlocConsumer<UploadPostBloc, UploadPostState>(
                        listener: (context, state) {
                          if (state is UploadPostFailureState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)),
                            );
                          } else if (state is UploadPostSuccessState) {
                            context.go('/homescreen');
                          }
                        },
                        builder: (context, state) {
                          if (state is UploadPostLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return PostButtonWidget(
                            onTapListener: () {
                              BlocProvider.of<UploadPostBloc>(context).add(
                                UploadPostPressedEvent(
                                  content: _contentController.text,
                                  location: const [0, 0],
                                ),
                              );
                            },
                            isActive: checkIsActive(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                _condition == 'post'
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 14.0, left: 14.0, right: 14.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60,
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      isActive =
                                          _titleController.text.isNotEmpty;
                                    });
                                  },
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    hintText: 'Title',
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType
                                      .multiline, // Allows for multiline input
                                  maxLines:
                                      null, // Allows the TextField to expand vertically
                                  minLines:
                                      1, // Sets the minimum number of lines to display
                                  expands:
                                      false, // Expands the TextField vertically to fill the parent container
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      // isActive = _contentController.text.isNotEmpty;
                                    });
                                  },
                                  controller: _contentController,
                                  decoration: const InputDecoration(
                                    hintText: 'What\'s on your mind?',
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType
                                      .multiline, // Allows for multiline input
                                  maxLines:
                                      null, // Allows the TextField to expand vertically
                                  minLines:
                                      1, // Sets the minimum number of lines to display
                                  expands:
                                      false, // Expands the TextField vertically to fill the parent container
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                _condition == 'poll'
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 14.0, left: 14.0, right: 14.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60,
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      isActive =
                                          _quesitonController.text.isNotEmpty;
                                    });
                                  },
                                  controller: _quesitonController,
                                  decoration: const InputDecoration(
                                    hintText: 'Write your question here...',
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType
                                      .multiline, // Allows for multiline input
                                  maxLines:
                                      null, // Allows the TextField to expand vertically
                                  minLines:
                                      1, // Sets the minimum number of lines to display
                                  expands:
                                      false, // Expands the TextField vertically to fill the parent container
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFieldWidget(
                                      border: true,
                                      onChanged: (value) {
                                        // setState(() {
                                        //   isPasswordFilled = _passwordController
                                        //       .text.isNotEmpty;
                                        // });
                                      },
                                      controller: _option1Controller,
                                      lableText: 'Option 1',
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    TextFieldWidget(
                                      border: true,
                                      onChanged: (value) {
                                        // setState(() {
                                        //   isPasswordFilled = _option2Controller
                                        //       .text.isNotEmpty;
                                        // });
                                      },
                                      controller: _option2Controller,
                                      lableText: 'Option 2',
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            bottomSheet: Container(
              color: Colors.white,
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      context.push('/upload-file');
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/add_a_photo.png'),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Add a Photo or GIF',
                          style: mediumTextStyleBlack,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset('assets/add_location.png'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Add Location',
                        style: mediumTextStyleBlack,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset('assets/create_an_event.png'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Create an Event',
                        style: mediumTextStyleBlack,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _condition = 'poll';
                      });
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/create_a_poll.png'),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Create a Poll',
                          style: mediumTextStyleBlack,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  // Future<dynamic> bottomSheet(BuildContext context) {
  //   return showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return
  //     },
  //   );
  // }
}
