import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/presentation/bloc/invite_state.dart';
import '../bloc/invite_bloc.dart';
import '../bloc/invite_event.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // You can optionally prefill the text field here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Invite Code")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Invite Code (optional)",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: BlocConsumer<InviteBloc, InviteState>(
                  listener: (context, state) {
                    if (state is InviteSuccess) {
                      context.go('/tutorialScreen');
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //       content:
                      //           Text("Invite code submitted successfully")),
                      // );
                      // Navigator.pop(context);
                    } else if (state is InviteError) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                    // },
                  },
                  builder: (context, state) {
                    if (state is InviteLoading) {
                      return Center(child: const CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryColor, // Background color
                        foregroundColor: Colors.white, // Text color
                        elevation: 4, // Shadow elevation
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        context.read<InviteBloc>().add(
                              SubmitInviteEvent(_controller.text.trim()),
                            );
                      },
                      child: const Text(
                        "Submit Invite",
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BlocConsumer<InviteBloc, InviteState>(
                  listener: (context, state) {
                    if (state is InviteSuccess) {
                      context.go('/tutorialScreen');
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //       content:
                      //           Text("Invite code submitted successfully")),
                      // );
                      // Navigator.pop(context);
                    } else if (state is InviteError) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    }
                    // },
                  },
                  builder: (context, state) {
                    if (state is InviteLoading) {
                      return Center(child: const CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryColor, // Background color
                        foregroundColor: Colors.white, // Text color
                        elevation: 4, // Shadow elevation
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        context.read<InviteBloc>().add(
                              SubmitInviteEvent(''),
                            );
                      },
                      child: const Text("Skip",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                          )),
                    );
                  },
                ),
              ),
              // Expanded(
              //   child: OutlinedButton(
              //     onPressed: () {
              //       context.go('/tutorialScreen');
              //       // context.go('/home');
              //       // Navigator.pop(context);
              //     },
              //     child: const Text("Skip"),
              //   ),
              // ),
            ],
          ),
        ]),
      ),
    );
  }
}
