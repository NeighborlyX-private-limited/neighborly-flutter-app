import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/update_block_user_bloc.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../bloc/community_detail_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  ///init state
  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    communityId = communityCubit.state.community?.id ?? '';
    blockedMembers = communityCubit.state.community?.blockList != null
        ? [...communityCubit.state.community!.blockList]
        : [];
    print('details:${communityCubit.state.community}');
  }

  Future<dynamic> bottomSheet(BuildContext context, String userId) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.are_you_sure_you_whant_to_Unblock_this_user,
               // 'Are you sure you whant to Unblock this user?',
                style: TextStyle(fontSize: 16),
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
                        //  'Cancel',
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
                        ///failure state
                        if (state is UpdateBlockUserFailureState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                            ),
                          );
                        }

                        ///success state
                        if (state is UpdateBlockSuccessState) {
                          communityCubit.getCommunityDetail(communityId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        ///loading state
                        if (state is UpdateBlockUserLoadingState) {
                          return CircularProgressIndicator(
                            color: AppColors.whiteColor,
                          );
                        }
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            BlocProvider.of<UpdateBlockUserBloc>(context)
                                .add(UpdateBlockUserButtonPressedEvent(
                              communityId: communityId,
                              userId: userId,
                              isBlock: false,
                            ));

                            // Navigator.pop(context);
                            // Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff635BFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              AppLocalizations.of(context)!.unblock,
                             // 'Unblock',
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

  Widget userTile(BuildContext context, UserSimpleModel user) {
    return GestureDetector(
      onTap: () {
        bottomSheet(context, user.id);
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
            // if (isAdmin) ...[
            //   const SizedBox(width: 5),
            //   Expanded(
            //     flex: 20,
            //     child: isAdminBubble(),
            //   ),
            // ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMembers = blockedMembers.isNotEmpty;
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
          AppLocalizations.of(context)!.blocked_User,
         // 'Blocked User',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (hasMembers == false)
              Expanded(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.no_Members,
                   // 'No Members',
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
}
