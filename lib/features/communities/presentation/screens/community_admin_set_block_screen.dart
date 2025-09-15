import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/update_block_user_bloc.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../bloc/community_detail_cubit.dart';
import '../../../../l10n/app_localizations.dart';

class CommunityAdminBlockedUsersScreen extends StatefulWidget {
  const CommunityAdminBlockedUsersScreen({
    super.key,
  });

  @override
  State<CommunityAdminBlockedUsersScreen> createState() =>
      _CommunityAdminBlockedUsersScreenState();
}

class _CommunityAdminBlockedUsersScreenState
    extends State<CommunityAdminBlockedUsersScreen> {
  late CommunityDetailsCubit communityCubit;
  late List<UserSimpleModel> blockedMembers;
  late String communityId;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    communityId = communityCubit.state.community?.id ?? '';
    blockedMembers = communityCubit.state.community?.blockList != null
        ? [...communityCubit.state.community!.blockList]
        : [];
    print(blockedMembers);
  }

// BUILD
  @override
  Widget build(BuildContext context) {
    final bool hasMembers = blockedMembers.isNotEmpty;
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
          AppLocalizations.of(context)!.blocked_User,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (hasMembers == false)
              Expanded(
                child: Center(
                  child: Text(
                    'No blocked members',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ...blockedMembers.map((user) => userTile(context, user)),
          ],
        ),
      ),
    );
  }

// COMMON TILE WIDGET
  Widget userTile(BuildContext context, UserSimpleModel user) {
    return GestureDetector(
      onTap: () {
        unblockBottomSheet(context, user.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserAvatarStyledWidget(
              avatarUrl: user.avatarUrl,
              avatarSize: 18,
              avatarBorderSize: 0,
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 50,
              child: Text(
                user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// UNBLOCK BOTTOM SHEET
  Future<dynamic> unblockBottomSheet(BuildContext context, String userId) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${AppLocalizations.of(context)!.are_you_sure_you_whant_to_Unblock_this_user} ?',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            height: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 40,
                    child:
                        BlocConsumer<UpdateBlockUserBloc, UpdateBlockUserState>(
                      listener: (context, state) {
                        // FAILURE STATE
                        if (state is UpdateBlockUserFailureState) {
                          Navigator.pop(context);
                          showSnackBar(context: context, message: state.error);
                        }

                        /// SUCCESS STATE
                        if (state is UpdateBlockSuccessState) {
                          Navigator.pop(context);
                          communityCubit.getCommunityDetail(communityId);
                          showSnackBar(
                            context: context,
                            message: state.message,
                          );
                        }
                      },
                      builder: (context, state) {
                        // LOADING STATE
                        if (state is UpdateBlockUserLoadingState) {
                          return CustomCircularIndicator();
                        }
                        return ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<UpdateBlockUserBloc>(context).add(
                              UpdateBlockUserButtonPressedEvent(
                                communityId: communityId,
                                userId: userId,
                                isBlock: false,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff635BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 17),
                            child: Text(
                              AppLocalizations.of(context)!.unblock,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 0.3,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
