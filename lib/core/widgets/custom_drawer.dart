import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/core/widgets/award_buy_bottom_sheet.dart';
import 'package:neighborly_flutter_app/core/widgets/language_bottom_sheet.dart';
import 'package:neighborly_flutter_app/core/widgets/svg_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/app_images.dart';

class CustomDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomDrawer({super.key, required this.scaffoldKey});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late String userName;
  late String userProPic;
  late String selectedCity;
  late String karma;
  late bool findMe;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    userName = ShardPrefHelper.getUsername() ?? '';
    userProPic = ShardPrefHelper.getUserProfilePicture() ?? '';
    selectedCity = ShardPrefHelper.getCity() ?? '';
    findMe = ShardPrefHelper.getFineMe();
    karma = ShardPrefHelper.getKarmaScore();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: AppColors.lightBackgroundColor,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // PROFILE PIC
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.network(
                            userProPic,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.whiteColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, exception, stackTrace) {
                              return CircleAvatar(
                                radius: 50,
                                backgroundColor:
                                    AppColors.whiteColor.withOpacity(0.2),
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.whiteColor,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // USER NAME
                      Text(
                        userName,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // CITY NAME
                      Text(
                        selectedCity,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // BUY AWARD OPTION
                ListTile(
                  tileColor: AppColors.whiteColor,
                  leading: CircularSvgImage(assetPath: AppImages.buyIcon),
                  title: Text(
                    AppLocalizations.of(context)!.buy_awards,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    widget.scaffoldKey.currentState?.closeEndDrawer();
                    showModalBottomSheet(
                      useRootNavigator: true,
                      showDragHandle: true,
                      backgroundColor: AppColors.whiteColor,
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const AwardSelectionScreen(),
                    );
                  },
                ),

                // SELECT APP LANGUAGE OPTION
                ListTile(
                  tileColor: AppColors.whiteColor,
                  leading: CircularSvgImage(assetPath: AppImages.languageIcon),
                  title: Text(
                    AppLocalizations.of(context)!.language,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
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

                // CHANGE LOCATION OPTION
                ListTile(
                  tileColor: AppColors.whiteColor,
                  leading: CircularSvgImage(assetPath: AppImages.locationIcon),
                  title: Text(
                    AppLocalizations.of(context)!.change_location,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    widget.scaffoldKey.currentState?.closeEndDrawer();
                    context.push('/locationScreen');
                  },
                ),

                // SET RADIUS OPTION
                ListTile(
                  tileColor: AppColors.whiteColor,
                  leading: CircularSvgImage(assetPath: AppImages.radiusIcon),
                  title: Text(
                    AppLocalizations.of(context)!.set_radius,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    widget.scaffoldKey.currentState?.closeEndDrawer();
                    context.push('/radiusScreen');
                  },
                ),

                // EDIT PROFILE OPTION
                ListTile(
                  tileColor: AppColors.whiteColor,
                  leading: CircularSvgImage(assetPath: AppImages.editIcon),
                  title: Text(
                    AppLocalizations.of(context)!.edit_profile_info,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    widget.scaffoldKey.currentState?.closeEndDrawer();
                    context.push('/basicInformationScreen');
                  },
                ),
              ],
            ),
          ),

          // SETTINGS OPTION AT THE BOTTOM
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              tileColor: AppColors.whiteColor,
              leading: CircularSvgImage(assetPath: AppImages.settingIcon),
              title: Text(
                AppLocalizations.of(context)!.settings,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                widget.scaffoldKey.currentState?.closeEndDrawer();
                context.push('/settingsScreen/$karma/$findMe');
              },
            ),
          ),
        ],
      ),
    );
  }
}
