import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/logout_bloc.dart/logout_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/button_widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void showLogoutBottomSheet() {
      logoutBottomSheet(context);
    }

    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios, size: 20),
          onTap: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          'Settings',
          style: blackNormalTextStyle,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General',
              style: blackNormalTextStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/basic_info.svg',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Basic Information',
                    style: blackonboardingBody1Style,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/community.svg',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Communities',
                    style: blackonboardingBody1Style,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                context.push('/activityAndStatsScreen');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/activity.svg',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Activity and Stats',
                    style: blackonboardingBody1Style,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                context.push('/securityScreen');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/security.svg',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Security',
                    style: blackonboardingBody1Style,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                context.push('/feedbackScreen');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/support.svg',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Support And Feedback',
                    style: blackonboardingBody1Style,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/delete.svg',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Delete account',
                    style: redOnboardingBody1Style,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                showLogoutBottomSheet();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/logout.svg',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Logout',
                    style: redOnboardingBody1Style,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> logoutBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: 160,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Leaving so soon? Confirm if you want to logout.',
                style: blackonboardingBody1Style,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonWidget(
                    color: const Color(0xffF5F5F5),
                    text: 'Cancel',
                    textColor: Colors.black,
                    onTapListener: () {
                      context.pop();
                    },
                    isActive: true,
                  ),
                  BlocConsumer<LogoutBloc, LogoutState>(
                    listener: (context, state) {
                      if (state is LogoutFailureState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                          ),
                        );
                      } else if (state is LogoutSuccessState) {
                        // remove the user info from the shared preferences
                        ShardPrefHelper.removeUserID();
                        ShardPrefHelper.removeCookie();
                        ShardPrefHelper.removeEmail();
                        ShardPrefHelper.removeImageUrl();
                        ShardPrefHelper.removeUserProfilePicture();
                        ShardPrefHelper.removeUsername();
                        // print('userId : ${ShardPrefHelper.getUserID()}');
                        // print('cookie : ${ShardPrefHelper.getCookie()}');
                        // print('email : ${ShardPrefHelper.getEmail()}');
                        // print('imageUrl : ${ShardPrefHelper.getImageUrl()}');
                        // print(
                        //     'imageUrl : ${ShardPrefHelper.getUserProfilePicture()}');
                        // print('usename : ${ShardPrefHelper.getUsername()}');
                        context.go('/loginScreen');
                      }
                    },
                    builder: (context, state) {
                      if (state is LogoutLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ButtonWidget(
                        color: const Color(0xffFD1D1D),
                        text: 'Logout',
                        textColor: Colors.white,
                        onTapListener: () {
                          context.read<LogoutBloc>().add(
                                LogoutButtonPressedEvent(),
                              );
                        },
                        isActive: true,
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
