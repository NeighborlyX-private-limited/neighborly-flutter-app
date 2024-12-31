import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/community_detail_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommunityAdminTypeScreen extends StatefulWidget {
  const CommunityAdminTypeScreen({
    super.key,
  });

  @override
  State<CommunityAdminTypeScreen> createState() =>
      _CommunityAdminTypeScreenState();
}

class _CommunityAdminTypeScreenState extends State<CommunityAdminTypeScreen> {
  late CommunityDetailsCubit communityCubit;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    selectedOption =
        communityCubit.state.community?.isPublic == true ? 'public' : 'private';
  }

  void _handleRadioValueChange(String? value) {
    setState(() {
      selectedOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.community_Type,
         // 'Community Type',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {
                communityCubit.updateType(
                    communityCubit.state.community?.id ?? '',
                    selectedOption ?? 'public');
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.save,
               // 'Save',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                 AppLocalizations.of(context)!.public,
               // 'Public',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:  Text(
                 AppLocalizations.of(context)!.anyone_can_join_see_posts_and_participate_in_discussions,
               // 'Anyone can join, see posts, and participate in discussions. ',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.lightBackgroundColor,
                ),
                child: Icon(
                  Icons.public,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
              trailing: Radio<String>(
                value:  AppLocalizations.of(context)!.public,
                // 'public',
                groupValue: selectedOption,
                onChanged: _handleRadioValueChange,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              title:  Text(
                 AppLocalizations.of(context)!.private,
               // 'Private',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                   AppLocalizations.of(context)!.only_invited_members_can_join_view_posts_and_engage_in_conversations,
               // 'Only invited members can join, view posts, and engage in conversations',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.lightBackgroundColor,
                ),
                child: Icon(
                  Icons.privacy_tip_outlined,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
              trailing: Radio<String>(
                value:  AppLocalizations.of(context)!.private,
                // 'private',
                groupValue: selectedOption,
                onChanged: _handleRadioValueChange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///menu button
class MenuIconItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double? iconSize;
  final String? svgPath;
  final VoidCallback onTap;
  final Color? textColor;
  const MenuIconItem({
    super.key,
    required this.title,
    this.icon = Icons.abc,
    this.iconSize = 20,
    this.svgPath = '',
    this.textColor = Colors.black,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            svgPath != ''
                ? SvgPicture.asset(
                    svgPath!,
                    width: iconSize,
                  )
                : Icon(
                    icon,
                    size: iconSize,
                  ),
            const SizedBox(width: 10),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.normal,
                fontSize: 18,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
