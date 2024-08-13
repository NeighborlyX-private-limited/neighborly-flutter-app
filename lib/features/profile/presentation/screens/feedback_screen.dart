import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/widgets/button_widget.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/send_feedback_bloc/send_feedback_bloc.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late TextEditingController _contentController;
  bool isSendFeedbackFilled = false;

  @override
  void initState() {
    _contentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: InkWell(
                child: const Icon(Icons.arrow_back_ios, size: 20),
                onTap: () => context.pop(),
              ),
              title: Text(
                'Support and Feedback',
                style: blackNormalTextStyle,
              ),
            ),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write your feedback here',
                      style: blackNormalTextStyle,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            isSendFeedbackFilled =
                                _contentController.text.trim().isNotEmpty;
                          });
                        },
                        controller: _contentController,
                        // focusNode: _contentFocusNode, // Attach the FocusNode
                        decoration: const InputDecoration(
                          hintText: 'Your feedback',
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    BlocConsumer<SendFeedbackBloc, SendFeedbackState>(
                      listener:
                          (BuildContext context, SendFeedbackState state) {
                        if (state is SendFeedbackFailureState) {
                          // if (state.error == 'SendFeedback has expired') {
                          //   setState(() {
                          //     isExpiredSendFeedback = true;
                          //   });
                          // }
                          // if (state.error.contains('Invalid SendFeedback')) {
                          //   setState(() {
                          //     isInvalidSendFeedback = true;
                          //   });
                          // }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        } else if (state is SendFeedbackSuccessState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Feedback submitted successfully')),
                          );
                          _contentController.clear();
                          context.pop();
                        }
                      },
                      builder: (context, state) {
                        if (state is SendFeedbackLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ButtonContainerWidget(
                          isActive: isSendFeedbackFilled,
                          color: AppColors.primaryColor,
                          text: 'Send',
                          isFilled: true,
                          onTapListener: () {
                            BlocProvider.of<SendFeedbackBloc>(context).add(
                              SendFeedbackEventButtonPressedEvent(
                                feedback: _contentController.text.trim(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ))));
  }
}
