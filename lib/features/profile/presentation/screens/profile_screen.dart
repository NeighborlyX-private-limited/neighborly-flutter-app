import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_profile_bloc/get_profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _fetchProfile() {
    BlocProvider.of<GetProfileBloc>(context)
        .add(GetProfileButtonPressedEvent()); // Use isHome state
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Profile',
            style: onboardingHeading2Style,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/settingsScreen');
            },
            icon: const Icon(
              Icons.settings_outlined,
              size: 25,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            BlocBuilder<GetProfileBloc, GetProfileState>(
              builder: (context, state) {
                if (state is GetProfileLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is GetProfileSuccessState) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        // Profile image
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 90,
                                height: 90,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  state.profile.picture,
                                  fit: BoxFit.contain,
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state.profile.username,
                          style: greyonboardingBody1Style,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '9',
                                  style: onboardingBlackBody2Style,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Post',
                                  style: mediumGreyTextStyleBlack,
                                ),
                              ],
                            ),
                            const SizedBox(width: 55),
                            Column(
                              children: [
                                Text(
                                  '9',
                                  style: onboardingBlackBody2Style,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Karma',
                                  style: mediumGreyTextStyleBlack,
                                ),
                              ],
                            ),
                            const SizedBox(width: 55),
                            Column(
                              children: [
                                Text(
                                  '9',
                                  style: onboardingBlackBody2Style,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Awards',
                                  style: mediumGreyTextStyleBlack,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                } else if (state is GetProfileFailureState) {
                  return Center(
                    child: Text(state.error),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    ));
  }
}
