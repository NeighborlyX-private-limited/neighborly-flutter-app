import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/award_buy_bottom_sheet.dart';
import 'package:neighborly_flutter_app/core/widgets/language_bottom_sheet.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/logout_bloc.dart/logout_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomDrawer({super.key, required this.scaffoldKey});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late String userName;
  late String userProPic;

  /// init method
  @override
  void initState() {
    super.initState();
    userName = ShardPrefHelper.getUsername() ?? '';
    userProPic = ShardPrefHelper.getUserProfilePicture() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    void showLogoutBottomSheet() {
      logoutBottomSheet(context);
    }

    /// drawer
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.60,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// App Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      color: AppColors.whiteColor,
                      'assets/logo.svg',
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(width: 10),

                    ///App Name
                    Text(
                      AppLocalizations.of(context)!.neighborly,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),

                  /// User profile pic
                  child: ClipOval(
                    child: Image.network(
                      userProPic,
                      loadingBuilder: (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.whiteColor,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (
                        BuildContext context,
                        Object exception,
                        StackTrace? stackTrace,
                      ) {
                        return CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 10),

                /// username
                Text(
                  userName,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          /// search
          // ListTile(
          //   leading: Icon(Icons.search),
          //   title: Text(AppLocalizations.of(context)!.search),
          //   onTap: () {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(
          //         content: Text("Coming Soon"),
          //       ),
          //     );
          //   },
          // ),

          /// payment
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(AppLocalizations.of(context)!.buy_awards),
            onTap: () {
              widget.scaffoldKey.currentState?.closeEndDrawer();
              showModalBottomSheet(
                showDragHandle: true,
                backgroundColor: AppColors.whiteColor,
                context: context,
                isScrollControlled: true,
                builder: (_) => const AwardSelectionScreen(),
              );
            },
          ),

          ///language
          ListTile(
            leading: Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.language),
            onTap: () {
              widget.scaffoldKey.currentState?.closeEndDrawer();
              showModalBottomSheet(
                backgroundColor: AppColors.whiteColor,
                showDragHandle: true,
                context: context,
                builder: (context) => LanguageBottomSheet(),
                isScrollControlled: true,
              );
            },
          ),

          /// set radius
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text(AppLocalizations.of(context)!.set_radius),
            onTap: () {
              widget.scaffoldKey.currentState?.closeEndDrawer();
              context.push('/radiusScreen');
            },
          ),

          /// edit profile info
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(AppLocalizations.of(context)!.edit_profile_info),
            onTap: () {
              widget.scaffoldKey.currentState?.closeEndDrawer();
              context.push('/basicInformationScreen');
            },
          ),

          Divider(),

          /// support and feedback
          ListTile(
            leading: Icon(Icons.help),
            title: Text(AppLocalizations.of(context)!.support_and_feedback),
            onTap: () {
              widget.scaffoldKey.currentState?.closeEndDrawer();
              context.push('/feedbackScreen');
            },
          ),

          ///logout
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout),
            onTap: () {
              widget.scaffoldKey.currentState?.closeEndDrawer();
              showLogoutBottomSheet();
            },
          ),
        ],
      ),
    );
  }

  /// logout bottom sheet
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
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        );
                      }
                      return ButtonWidget(
                        color: AppColors.redColor,
                        text: AppLocalizations.of(context)!.logout,
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
}
