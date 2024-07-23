import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/text_field_widget.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/logout_bloc.dart/logout_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/button_widget.dart';

class SettingScreen extends StatelessWidget {
  final String karma;
  final bool findMe;
  const SettingScreen({super.key, required this.karma, required this.findMe});

  @override
  Widget build(BuildContext context) {
    void showLogoutBottomSheet() {
      logoutBottomSheet(context);
    }

    void showVerifyUsernameBottomSheet() {
      verifyUsernameBottomSheet(context);
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
              onTap: () {
                context.push('/basicInformationScreen');
              },
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
              onTap: () {
                context.push('/communitiesScreen');
              },
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
                context.push('/activityAndStatsScreen/$karma');
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
                context.push('/findMeScreen');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/find-me.svg',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Find Me',
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
              onTap: () {
                showVerifyUsernameBottomSheet();
                // showdeleteBottomSheet();
              },
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

  Future<void> verifyUsernameBottomSheet(BuildContext context) {
    void showDeleteBottomSheet() {
      deleteBottomSheet(context);
    }

    TextEditingController _userNameController = TextEditingController();
    bool isUserNameFilled = false;
    bool isUsernameWrong = false;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            'Verify your username.',
                            style: onboardingHeading2Style,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          border: true,
                          onChanged: (value) {
                            setState(() {
                              isUserNameFilled =
                                  _userNameController.text.trim().isNotEmpty;
                              isUsernameWrong =
                                  false; // Reset error message on change
                            });
                          },
                          controller: _userNameController,
                          lableText: 'Enter your username',
                          isPassword: false,
                        ),
                        isUsernameWrong
                            ? const Text(
                                'Wrong username',
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.red),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonWidget(
                              color: const Color(0xffF5F5F5),
                              text: 'Cancel',
                              textColor: Colors.black,
                              onTapListener: () {
                                Navigator.pop(context);
                              },
                              isActive: isUserNameFilled,
                            ),
                            ButtonWidget(
                              color: AppColors.primaryColor,
                              text: 'Verify',
                              textColor: Colors.white,
                              onTapListener: () {
                                String? userName =
                                    ShardPrefHelper.getUsername();

                                if (_userNameController.text.trim() ==
                                    userName) {
                                  Navigator.pop(context);
                                  showDeleteBottomSheet();
                                } else {
                                  setState(() {
                                    isUsernameWrong = true;
                                  });
                                }
                              },
                              isActive: isUserNameFilled,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
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
                        if (ShardPrefHelper.getEmail() != null) {
                          ShardPrefHelper.removeEmail();
                        }
                        ShardPrefHelper.removeImageUrl();
                        ShardPrefHelper.removeUserProfilePicture();
                        ShardPrefHelper.removeUsername();
                        ShardPrefHelper.removePhoneNumber();
                        ShardPrefHelper.removeGender();

                        context.go('/');
                      }
                    },
                    builder: (context, state) {
                      if (state is LogoutLoadingState) {
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: CircularProgressIndicator()),
                          ],
                        );
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

  Future<void> deleteBottomSheet(BuildContext context) {
// Function to delete all data related to a specific user ID
    Future<void> deleteUserPostData(String userID) async {
      final box = Hive.box('postReactions');

      // Iterate through all keys in the box
      List<String> keysToRemove = [];
      for (var key in box.keys) {
        if (key.startsWith(userID)) {
          keysToRemove.add(key);
        }
      }

      // Remove all entries that match the user ID
      for (var key in keysToRemove) {
        await box.delete(key);
      }
    }

    Future<void> deleteUserCommentData(String userID) async {
      final box = Hive.box('commentReactions');

      // Iterate through all keys in the box
      List<String> keysToRemove = [];
      for (var key in box.keys) {
        if (key.startsWith(userID)) {
          keysToRemove.add(key);
        }
      }

      // Remove all entries that match the user ID
      for (var key in keysToRemove) {
        await box.delete(key);
      }
    }

    Future<void> deleteUserReplyData(String userID) async {
      final box = Hive.box('replyReactions');

      // Iterate through all keys in the box
      List<String> keysToRemove = [];
      for (var key in box.keys) {
        if (key.startsWith(userID)) {
          keysToRemove.add(key);
        }
      }

      // Remove all entries that match the user ID
      for (var key in keysToRemove) {
        await box.delete(key);
      }
    }

    Future<void> deleteUserVoteData(String userID) async {
      final box = Hive.box('pollVotes');

      // Iterate through all keys in the box
      List<String> keysToRemove = [];
      for (var key in box.keys) {
        if (key.startsWith(userID)) {
          keysToRemove.add(key);
        }
      }

      // Remove all entries that match the user ID
      for (var key in keysToRemove) {
        await box.delete(key);
      }
    }

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
                'Are you sure you want to delete your account? This action is irreversible.',
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
                        deleteUserPostData(ShardPrefHelper.getUserID()!);
                        deleteUserCommentData(ShardPrefHelper.getUserID()!);
                        deleteUserReplyData(ShardPrefHelper.getUserID()!);
                        deleteUserVoteData(ShardPrefHelper.getUserID()!);

                        ShardPrefHelper.removeUserID();
                        ShardPrefHelper.removeCookie();
                        if (ShardPrefHelper.getEmail() != null) {
                          ShardPrefHelper.removeEmail();
                        }
                        ShardPrefHelper.removeImageUrl();
                        ShardPrefHelper.removeUserProfilePicture();
                        ShardPrefHelper.removeUsername();
                        ShardPrefHelper.removePhoneNumber();
                        ShardPrefHelper.removeGender();

                        context.go('/registerScreen');
                      }
                    },
                    builder: (context, state) {
                      if (state is LogoutLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ButtonWidget(
                        color: const Color(0xffFD1D1D),
                        text: 'Delete',
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
