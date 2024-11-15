import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/logout_bloc.dart/logout_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/button_widget.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomDrawer({super.key, required this.scaffoldKey});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late String userName;
  late String userProPic;
  @override
  void initState() {
    super.initState();
    userName = ShardPrefHelper.getUsername() ?? '';
    userProPic = ShardPrefHelper.getUserProfilePicture() ?? '';
    print(userProPic);
  }

  @override
  Widget build(BuildContext context) {
    void showLogoutBottomSheet() {
      logoutBottomSheet(context);
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Custom Header with App Logo and User Info
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
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
                    Text(
                      'Neighborly', // Replace with your app name
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                // User Info
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      userProPic, // Replace with your image URL
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Text(
                            'Failed to load image'); // Show an error message if the image fails to load
                      },
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  userName!,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // // Navigation Items
          // ListTile(
          //   leading: Icon(Icons.person),
          //   title: Text('Profile'),
          //   onTap: () {
          //     widget.scaffoldKey.currentState?.closeEndDrawer();
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Set Radius'),
            onTap: () {
              widget.scaffoldKey.currentState?.closeEndDrawer();
              context.push('/radiusScreen');
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile Info'),
            onTap: () {
              widget.scaffoldKey.currentState?.closeEndDrawer();
              context.push('/basicInformationScreen');
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            onTap: () {
              widget.scaffoldKey.currentState?.closeEndDrawer();
            },
          ),
          Divider(),

          // Other Options
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Support & Feedback'),
            onTap: () {
              widget.scaffoldKey.currentState?.closeEndDrawer();
              context.push('/feedbackScreen');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              widget.scaffoldKey.currentState?.closeEndDrawer();
              showLogoutBottomSheet();
            },
          ),
        ],
      ),
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
                    color: AppColors.lightBackgroundColor,
                    text: 'Cancel',
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
                            Center(child: CircularProgressIndicator(),),
                          ],
                        );
                      }
                      return ButtonWidget(
                        color: AppColors.redColor,
                        text: 'Logout',
                        textColor: AppColors.whiteColor,
                        onTapListener: () {
                          context
                              .read<LogoutBloc>()
                              .add(LogoutButtonPressedEvent(),);
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
