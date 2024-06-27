import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/upload/presentation/bloc/upload_poll_bloc/upload_poll_bloc.dart';
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

  bool isActive = false;
  bool isQuestionFilled = false;
  bool isOption1Filled = false;
  bool isTitleFilled = false;
  bool isOption2Filled = false;

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

  bool checkIsPollActive() {
    if (isQuestionFilled && isOption1Filled && isOption2Filled) {
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
    String? url = ShardPrefHelper.getImageUrl();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          // Make content scrollable
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 14.0, left: 14.0, right: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: const Icon(Icons.close, size: 30),
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
                    _condition == 'post'
                        ? BlocConsumer<UploadPostBloc, UploadPostState>(
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
                                    child: CircularProgressIndicator());
                              }
                              return PostButtonWidget(
                                onTapListener: () async {
                                  List<double> location =
                                      ShardPrefHelper.getLocation();

                                  List<Placemark> placemarks =
                                      await placemarkFromCoordinates(
                                          location[0], location[1]);

                                  BlocProvider.of<UploadPostBloc>(context).add(
                                    UploadPostPressedEvent(
                                      city: placemarks[0].locality ?? '',
                                      content: _contentController.text,
                                      location: location,
                                      title: _titleController.text,
                                      type: 'post',
                                    ),
                                  );
                                },
                                isActive: isTitleFilled,
                              );
                            },
                          )
                        : BlocConsumer<UploadPollBloc, UploadPollState>(
                            listener: (context, state) {
                              if (state is UploadPollFailureState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error)),
                                );
                              } else if (state is UploadPollSuccessState) {
                                _quesitonController.clear();
                                _option1Controller.clear();
                                _option2Controller.clear();
                              }
                            },
                            builder: (context, state) {
                              if (state is UploadPollLoadingState) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return PostButtonWidget(
                                onTapListener: () {
                                  BlocProvider.of<UploadPollBloc>(context).add(
                                    UploadPollPressedEvent(
                                      question: _quesitonController.text,
                                      options: [
                                        _option1Controller.text,
                                        _option2Controller.text,
                                      ],
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
              if (_condition == 'post')
                url == null
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(url, fit: BoxFit.contain),
                      ),
              if (_condition == 'post')
                Padding(
                  padding:
                      const EdgeInsets.only(top: 14.0, left: 14.0, right: 14.0),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            isTitleFilled = _titleController.text.isNotEmpty;
                          });
                        },
                        controller: _titleController,
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
                  padding:
                      const EdgeInsets.only(top: 14.0, left: 14.0, right: 14.0),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            isQuestionFilled =
                                _quesitonController.text.isNotEmpty;
                          });
                        },
                        controller: _quesitonController,
                        decoration: const InputDecoration(
                          hintText: 'Write your question here...',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 1,
                      ),
                      const SizedBox(height: 12),
                      TextFieldWidget(
                        border: true,
                        onChanged: (value) {
                          setState(() {
                            isOption1Filled =
                                _option1Controller.text.isNotEmpty;
                          });
                        },
                        controller: _option1Controller,
                        lableText: 'Option 1',
                      ),
                      const SizedBox(height: 12),
                      TextFieldWidget(
                        border: true,
                        onChanged: (value) {
                          setState(() {
                            isOption2Filled =
                                _option2Controller.text.isNotEmpty;
                          });
                        },
                        controller: _option2Controller,
                        lableText: 'Option 2',
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 200), // Space to accommodate the bottom sheet
            ],
          ),
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
                  context.push('/media-preview');
                },
                child: Row(
                  children: [
                    Image.asset('assets/add_a_photo.png'),
                    const SizedBox(width: 10),
                    Text('Add a Photo or GIF', style: mediumTextStyleBlack),
                  ],
                ),
              ),
              Row(
                children: [
                  Image.asset('assets/add_location.png'),
                  const SizedBox(width: 10),
                  Text('Add Location', style: mediumTextStyleBlack),
                ],
              ),
              Row(
                children: [
                  Image.asset('assets/create_an_event.png'),
                  const SizedBox(width: 10),
                  Text('Create an Event', style: mediumTextStyleBlack),
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
                    const SizedBox(width: 10),
                    Text('Create a Poll', style: mediumTextStyleBlack),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
