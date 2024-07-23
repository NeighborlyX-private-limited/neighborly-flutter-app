import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_profile_bloc/get_profile_bloc.dart';

class FindMeScreen extends StatefulWidget {
  const FindMeScreen({super.key});

  @override
  State<FindMeScreen> createState() => _FindMeScreenState();
}

class _FindMeScreenState extends State<FindMeScreen> {
  bool allowFindMe = false;

  @override
  void initState() {
    super.initState();
    // var postState = context.read<GetProfileBloc>().state;
    // if (postState is! GetProfileSuccessState) {
    BlocProvider.of<GetProfileBloc>(context)
        .add(GetProfileButtonPressedEvent());
    // }
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
            'Find Me',
            style: blackNormalTextStyle,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: BlocConsumer<GetProfileBloc, GetProfileState>(
              listener: (context, state) {
                if (state is GetProfileSuccessState) {
                  setState(() {
                    allowFindMe = state.profile.findMe!;
                  });
                }
              },
              builder: (context, state) {
                if (state is GetProfileSuccessState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/find-me2.svg',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Find me',
                              style: blackonboardingBody2Style,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'You will automatically join the community group when it is created.',
                              style: mediumGreyTextStyleBlack,
                              softWrap: true, // Enables text wrapping
                            ),
                          ],
                        ),
                      ),
                      BlocListener<EditProfileBloc, EditProfileState>(
                        listener: (context, state) {
                          if (state is EditProfileSuccessState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Find me updated successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (state is EditProfileFailureState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Switch(
                          value: allowFindMe,
                          onChanged: (value) {
                            setState(() {
                              allowFindMe = value;
                            });
                            String? userName = ShardPrefHelper.getUsername();
                            String? gender = ShardPrefHelper.getGender();
                            print('find Me $allowFindMe');

                            BlocProvider.of<EditProfileBloc>(context).add(
                              EditProfileButtonPressedEvent(
                                toggleFindMe: allowFindMe,
                                username: userName ?? 'Default User',
                                gender: gender ?? 'Male',
                              ),
                            );
                          },
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                          activeTrackColor: const Color(0xff635BFF),
                          activeColor: Colors.white,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
