import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/colors.dart';
import '../bloc/community_detail_cubit.dart';

class CommunityAdminTypeScreen extends StatefulWidget {
  const CommunityAdminTypeScreen({
    Key? key,
  }) : super(key: key);

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
          'Community Type',
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
                print('SAVE');
                communityCubit.updateType(
                    communityCubit.state.community?.id ?? '',
                    selectedOption ?? 'public');
                Navigator.of(context).pop();
              },
              child: Text(
                'Save',
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
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //
            //
            ListTile(
              title: const Text(
                'Public',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Anyone can join, see posts, and participate in discussions. ',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.lightBackgroundColor,
                  // color: Colors.red,
                ),
                child: Icon(
                  Icons.public,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
              trailing: Radio<String>(
                value: 'public',
                groupValue: selectedOption,
                onChanged: _handleRadioValueChange,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //
            //
            ListTile(
              title: const Text(
                'Private',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Only invited members can join, view posts, and engage in conversations',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.lightBackgroundColor,
                  // color: Colors.red,
                ),
                child: Icon(
                  Icons.privacy_tip_outlined,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
              trailing: Radio<String>(
                value: 'private',
                groupValue: selectedOption,
                onChanged: _handleRadioValueChange,
              ),
            ),
            //
            //
          ],
        ),
      ),
    );
  }
}

// ########################################################################
// ########################################################################
// ########################################################################

// ########################################################################
// ########################################################################
// ########################################################################

class MenuIconItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double? iconSize;
  final String? svgPath;
  final VoidCallback onTap;
  final Color? textColor;
  const MenuIconItem({
    Key? key,
    required this.title,
    this.icon = Icons.abc,
    this.iconSize = 20,
    this.svgPath = '',
    this.textColor = Colors.black,
    required this.onTap,
  }) : super(key: key);

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
              '${title}',
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
