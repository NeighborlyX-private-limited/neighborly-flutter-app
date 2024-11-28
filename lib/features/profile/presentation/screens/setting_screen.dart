import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:neighborly_flutter_app/core/widgets/award_buy_bottom_sheet.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/language_bottom_sheet.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/delete_account_bloc/delete_account_bloc.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/text_field_widget.dart';
import '../bloc/logout_bloc.dart/logout_bloc.dart';
import '../widgets/button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingScreen extends StatefulWidget {
  final String karma;
  final bool findMe;
  const SettingScreen({super.key, required this.karma, required this.findMe});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late bool isShowSecurityOption;
  @override
  void initState() {
    super.initState();
    isShowSecurityOption = ShardPrefHelper.getIsEmailLogin();
  }

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
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios, size: 20),
          onTap: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.settings,
          // 'Settings',
          style: blackNormalTextStyle,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.general,
              // 'General',
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
                    AppLocalizations.of(context)!.basic_information,
                    // 'Basic Information',
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
                context.push('/radiusScreen');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/menu_location.svg',
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.set_radius,
                    // 'Set Radius',
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
                context.push('/activityAndStatsScreen/${widget.karma}');
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
                    AppLocalizations.of(context)!.activity_and_stats,
                    // 'Activity and Stats',
                    style: blackonboardingBody1Style,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            isShowSecurityOption
                ? InkWell(
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
                          AppLocalizations.of(context)!.security,
                          // 'Security',
                          style: blackonboardingBody1Style,
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            isShowSecurityOption
                ? const SizedBox(
                    height: 20,
                  )
                : SizedBox(),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: AppColors.whiteColor,
                  showDragHandle: true,
                  context: context,
                  builder: (context) => LanguageBottomSheet(),
                  isScrollControlled: true,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.language),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.language,
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
                showModalBottomSheet(
                  showDragHandle: true,
                  backgroundColor: AppColors.whiteColor,
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const AwardSelectionScreen(),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.payment),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.buy_awards,
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
                    AppLocalizations.of(context)!.find_me,
                    // 'Find Me',
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
                    AppLocalizations.of(context)!.support_and_feedback,
                    // 'Support And Feedback',
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
                    AppLocalizations.of(context)!.delete_account,
                    // 'Delete account',
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
                    AppLocalizations.of(context)!.logout,
                    // 'Logout',
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

    TextEditingController userNameController = TextEditingController();
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
                      color: AppColors.whiteColor,
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
                            AppLocalizations.of(context)!.verify_your_username,
                            // 'Verify your username.',
                            style: onboardingHeading2Style,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          border: true,
                          onChanged: (value) {
                            setState(() {
                              isUserNameFilled =
                                  userNameController.text.trim().isNotEmpty;
                              isUsernameWrong = false;
                            });
                          },
                          controller: userNameController,
                          lableText:
                              AppLocalizations.of(context)!.enter_your_username,
                          // lableText: 'Enter your username',
                          isPassword: false,
                        ),
                        isUsernameWrong
                            ? Text(
                                AppLocalizations.of(context)!.wrong_username,
                                // 'Wrong username',
                                textAlign: TextAlign.left,
                                style: TextStyle(color: AppColors.redColor),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ButtonWidget(
                              color: const Color(0xffF5F5F5),
                              text: AppLocalizations.of(context)!.cancel,
                              // text: 'Cancel',
                              textColor: AppColors.blackColor,
                              onTapListener: () {
                                Navigator.pop(context);
                              },
                              isActive: isUserNameFilled,
                            ),
                            ButtonWidget(
                              color: AppColors.primaryColor,
                              text: AppLocalizations.of(context)!.verify,
                              // text: 'Verify',
                              textColor: AppColors.whiteColor,
                              onTapListener: () {
                                String? userName =
                                    ShardPrefHelper.getUsername();

                                if (userNameController.text.trim() ==
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
            color: AppColors.whiteColor,
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
                AppLocalizations.of(context)!
                    .leaving_so_soon_confirm_if_you_want_to_logout,
                // 'Leaving so soon? Confirm if you want to logout.',
                style: blackonboardingBody1Style,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonWidget(
                    color: AppColors.lightBackgroundColor,
                    text: AppLocalizations.of(context)!.cancel,
                    // text: 'Cancel',
                    textColor: AppColors.blackColor,
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
                            // Center(
                            //   child: BouncingLogoIndicator(
                            //     logo: 'images/logo.svg',
                            //   ),
                            // ),
                            Center(child: CircularProgressIndicator()),
                          ],
                        );
                      }
                      return ButtonWidget(
                        color: AppColors.redColor,
                        text: AppLocalizations.of(context)!.logout,
                        // text: 'Logout',
                        textColor: AppColors.whiteColor,
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
            color: AppColors.whiteColor,
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
                // 'Are you sure you want to delete your account? This action is irreversible.',
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_to_delete_your_account_this_action_is_irreversible,
                style: blackonboardingBody1Style,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonWidget(
                    color: AppColors.lightBackgroundColor,
                    text: AppLocalizations.of(context)!.cancel,
                    // text: 'Cancel',
                    textColor: AppColors.blackColor,
                    onTapListener: () {
                      context.pop();
                    },
                    isActive: true,
                  ),
                  BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
                    listener: (context, state) {
                      if (state is DeleteAccountFailureState) {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .oops_something_went_wrong),
                            // content: Text('Something went wrong'),
                          ),
                        );
                      } else if (state is DeleteAccountSuccessState) {
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
                        context.pop();
                        context.go('/registerScreen');
                      }
                    },
                    builder: (context, state) {
                      if (state is DeleteAccountLoadingState) {
                        return Center(
                          child: BouncingLogoIndicator(
                            logo: 'images/logo.svg',
                          ),
                        );
                        // return const Center(child: CircularProgressIndicator());
                      }
                      return ButtonWidget(
                        color: AppColors.redColor,
                        text: AppLocalizations.of(context)!.delete,
                        // text: 'Delete',
                        textColor: AppColors.whiteColor,
                        onTapListener: () {
                          context.read<DeleteAccountBloc>().add(
                                DeleteAccountButtonPressedEvent(),
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
