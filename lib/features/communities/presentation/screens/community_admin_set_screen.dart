import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/community_detail_cubit.dart';
import '../../../../core/models/community_model.dart';
import '../bloc/bloc/update_mute_group_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommunityAdminSetScreen extends StatefulWidget {
  final CommunityModel community;

  const CommunityAdminSetScreen({
    super.key,
    required this.community,
  });

  @override
  State<CommunityAdminSetScreen> createState() =>
      _CommunityAdminSetScreenState();
}

class _CommunityAdminSetScreenState extends State<CommunityAdminSetScreen> {
  late CommunityDetailsCubit communityDetailCubit;
  late String communitytId;
  late CommunityModel community;

  ///init state method
  @override
  void initState() {
    super.initState();
    communityDetailCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    community = communityDetailCubit.state.community ?? widget.community;
    communitytId = community.id;
  }

  /// delete group confirmation bottom sheet
  void _showConfirmGroupDeletionSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      barrierColor: AppColors.whiteColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
               AppLocalizations.of(context)!.delete_Group,
              // 'Delete Group',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
               AppLocalizations.of(context)!.are_you_sure_you_want_to_delete_your_account_this_action_is_irreversible,
               // 'Are you sure you want to delete this group? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.grey[300],
                    ),
                    child: Text(
                        AppLocalizations.of(context)!.cancel,
                     // 'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      communityDetailCubit.deleteCommunity(communitytId);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text(
                          AppLocalizations.of(context)!.group_deleted,
                         // 'Group deleted'
                          )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.delete,
                     // 'Delete',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
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
          AppLocalizations.of(context)!.group_settings,
         // 'Group settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///general
              Text(
                AppLocalizations.of(context)!.general,
              //  'General',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 5),

              ///community name
              MenuIconItem(
                title: AppLocalizations.of(context)!.community_name,
                // 'Community name',
                svgPath: 'assets/menu_members.svg',
                iconSize: 25,
                onTap: () {
                  context.push('/groups/admin/displayname');
                },
              ),

              /// community description
              MenuIconItem(
                title: AppLocalizations.of(context)!.description,
                // 'Description',
                svgPath: 'assets/menu_description.svg',
                iconSize: 25,
                onTap: () {
                  context.push('/groups/admin/description');
                },
              ),

              /// community type
              MenuIconItem(
                title: AppLocalizations.of(context)!.community_Type,
                // 'Community Type',
                svgPath: 'assets/menu_type.svg',
                iconSize: 25,
                onTap: () {
                  context.push('/groups/admin/type');
                },
              ),

              ///community icon
              MenuIconItem(
                title: AppLocalizations.of(context)!.community_Icon,
                // 'Community Icon',
                svgPath: 'assets/menu_icon.svg',
                iconSize: 25,
                onTap: () {
                  context.push('/groups/admin/icon');
                },
              ),

              ///location
              // const SizedBox(height: 5),
              // MenuIconItem(
              //   title: 'Location',
              //   svgPath: 'assets/menu_location.svg',
              //   iconSize: 25,
              //   onTap: () {
              //     context.push('/groups/admin/location');
              //   },
              // ),

              ///radius
              // const SizedBox(height: 5),
              // MenuIconItem(
              //   title: 'Radius',
              //   svgPath: 'assets/menu_location_.svg',
              //   iconSize: 25,
              //   onTap: () {
              //     context.push('/groups/admin/radius');
              //   },
              // ),
              /// mute/unmute
              BlocConsumer<UpdateMuteGroupBloc, UpdateMuteGroupState>(
                listener: (context, state) {
                  /// failure state
                  if (state is UpdateMuteGroupFailureState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                      ),
                    );
                  }

                  /// success state
                  if (state is UpdateMuteGroupSuccessState) {
                    community.copyWith(isMuted: !(community.isMuted));
                    communityDetailCubit.getCommunityDetail(community.id);
                    String msg =
                        community.isMuted ? AppLocalizations.of(context)!.group_unmuted : AppLocalizations.of(context)!.group_muted;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  ///loading state
                  if (state is UpdateMuteGroupLoadingState) {
                    return CircularProgressIndicator();
                  }
                  // if (state is UpdateMuteGroupSuccessState) {
                  //   community.copyWith(isMuted: !(community.isMuted));
                  //   community = communityDetailCubit.state.community!;
                  // }
                  return MenuIconItem(
                    title: community.isMuted ? AppLocalizations.of(context)!.unmute :AppLocalizations.of(context)!.mute,
                    svgPath: community.isMuted
                        ? 'assets/menu_unmute.svg'
                        : 'assets/menu_mute.svg',
                    iconSize: 25,
                    onTap: () {
                      BlocProvider.of<UpdateMuteGroupBloc>(context)
                          .add(UpdateMuteGroupButtonPressedEvent(
                        communityId: community.id,
                        isMute: !community.isMuted,
                      ));

                      Navigator.pop(context);
                    },
                  );
                },
              ),
              const SizedBox(height: 5),

              ///member list
              MenuIconItem(
                title: AppLocalizations.of(context)!.member_list,
                // 'Member list',
                svgPath: 'assets/menu_members.svg',
                iconSize: 25,
                onTap: () {
                  context.push('/groups/admin/members');
                },
              ),

              const SizedBox(height: 5),

              ///block user list
              MenuIconItem(
                title: AppLocalizations.of(context)!.blocked_User,
                 //'Blocked users',
                svgPath: 'assets/menu_block.svg',
                iconSize: 25,
                onTap: () {
                  print('Tapped');
                  context.push('/groups/admin/blocked');
                },
              ),

              const SizedBox(height: 5),

              ///delete group
              MenuIconItem(
                title: AppLocalizations.of(context)!.delete_community,
                 //'Delete community',
                svgPath: 'assets/menu_remove.svg',
                iconSize: 25,
                onTap: () {
                  _showConfirmGroupDeletionSheet(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// menu button
class MenuIconItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double? iconSize;
  final String? svgPath;
  final VoidCallback onTap;
  const MenuIconItem({
    super.key,
    required this.title,
    this.icon = Icons.abc,
    this.iconSize = 20,
    this.svgPath = '',
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
                color: Colors.black,
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
