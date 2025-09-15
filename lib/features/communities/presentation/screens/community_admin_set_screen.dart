import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/status.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/communities_main_cubit.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/community_detail_cubit.dart';
import '../../../../core/models/community_model.dart';
import '../bloc/bloc/update_mute_group_bloc.dart';
import '../../../../l10n/app_localizations.dart';

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
  late CommunityMainCubit communityMainCubit;
  late String communitytId;
  late CommunityModel community;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    communityDetailCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    communityMainCubit = BlocProvider.of<CommunityMainCubit>(context);
    community = communityDetailCubit.state.community ?? widget.community;
    communitytId = community.id;
  }

  Future<void> _onRefresh() async {}

// BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.group_settings,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(15),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MEMBERS LIST
                MenuIconItem(
                  title: AppLocalizations.of(context)!.member_list,
                  svgPath: 'assets/menu_members.svg',
                  iconSize: 25,
                  onTap: () {
                    context.push('/group-members');
                  },
                ),

                const SizedBox(height: 5),

                // JOIN REQUEST LIST
                MenuIconItem(
                  title: "Manage Join Request",
                  svgPath: 'assets/private-lock-icon.svg',
                  iconSize: 25,
                  onTap: () {
                    context.push('/manage-group-join-request/${community.id}');
                  },
                ),

                const SizedBox(height: 5),

                // COMMUNITY ICON
                MenuIconItem(
                  title: AppLocalizations.of(context)!.community_Icon,
                  svgPath: 'assets/menu_icon.svg',
                  iconSize: 25,
                  onTap: () {
                    context.push('/group-icon');
                  },
                ),
                const SizedBox(height: 5),

                // COMMUNITY DESCRIPTION
                MenuIconItem(
                  title: AppLocalizations.of(context)!.description,
                  svgPath: 'assets/menu_description.svg',
                  iconSize: 25,
                  onTap: () {
                    context.push('/group-description');
                  },
                ),
                const SizedBox(height: 5),

                // COMMUNITY NAME
                MenuIconItem(
                  title: AppLocalizations.of(context)!.community_name,
                  svgPath: 'assets/menu_members.svg',
                  iconSize: 25,
                  onTap: () {
                    context.push('/group-displayname');
                  },
                ),

                // COMMUNITY TYPE
                MenuIconItem(
                  title: AppLocalizations.of(context)!.community_Type,
                  svgPath: 'assets/menu_type.svg',
                  iconSize: 25,
                  onTap: () {
                    context.push('/group-type'); // Wait for screen pop
                  },
                ),

                // COMMUNITY MUTE-UNMUTE
                BlocConsumer<UpdateMuteGroupBloc, UpdateMuteGroupState>(
                  listener: (context, state) {
                    // FAILURE STATE
                    if (state is UpdateMuteGroupFailureState) {
                      showSnackBar(
                        context: context,
                        message: state.error,
                      );
                    }

                    // SUCCESS STATE
                    if (state is UpdateMuteGroupSuccessState) {
                      Navigator.pop(context);
                      community.copyWith(isMuted: !(community.isMuted));
                      communityDetailCubit.getCommunityDetail(community.id);
                      String msg = community.isMuted
                          ? AppLocalizations.of(context)!.group_unmuted
                          : AppLocalizations.of(context)!.group_muted;
                      showSnackBar(
                        context: context,
                        message: msg,
                      );
                    }
                  },
                  builder: (context, state) {
                    // LOADING STATE
                    if (state is UpdateMuteGroupLoadingState) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomCircularIndicator(),
                          ],
                        ),
                      );
                    }

                    return MenuIconItem(
                      title: community.isMuted
                          ? AppLocalizations.of(context)!.unmute
                          : AppLocalizations.of(context)!.mute,
                      svgPath: community.isMuted
                          ? 'assets/menu_unmute.svg'
                          : 'assets/menu_mute.svg',
                      iconSize: 25,
                      onTap: () {
                        BlocProvider.of<UpdateMuteGroupBloc>(context).add(
                          UpdateMuteGroupButtonPressedEvent(
                            communityId: community.id,
                            isMute: !community.isMuted,
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 5),

                // BLOCK LIST
                MenuIconItem(
                  title: AppLocalizations.of(context)!.blocked_User,
                  svgPath: 'assets/menu_block.svg',
                  iconSize: 25,
                  onTap: () {
                    context.push('/group-blocked');
                  },
                ),

                const SizedBox(height: 5),

                // DELETE GROUP
                MenuIconItem(
                  title: AppLocalizations.of(context)!.delete_community,
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
      ),
    );
  }

  // DELETE GROUP BOTTOM SHEET
  void _showConfirmGroupDeletionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.delete_Group,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!
                    .are_you_sure_you_want_to_delete_your_account_this_action_is_irreversible,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // CANCEL BUTTON
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.grey[300],
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // DELETE BUTTON
                  Expanded(
                    child: BlocConsumer<CommunityDetailsCubit,
                        CommunityDetailsState>(
                      listener: (context, state) {
                        if (state.status == Status.failure) {
                          Navigator.pop(context);
                          showSnackBar(
                            context: context,
                            message: state.failure?.message ??
                                'oops something went wrong',
                          );
                        }
                        if (state.status == Status.success) {
                          Navigator.pop(context);
                          context.go('/groups');
                          showSnackBar(
                            context: context,
                            message:
                                AppLocalizations.of(context)!.group_deleted,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state.status == Status.loading) {
                          return CustomCircularIndicator();
                        }

                        return ElevatedButton(
                          onPressed: () {
                            communityDetailCubit.deleteCommunity(communitytId);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.primaryColor,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.delete,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
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
}

// COMMON TILE WIDGET
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
