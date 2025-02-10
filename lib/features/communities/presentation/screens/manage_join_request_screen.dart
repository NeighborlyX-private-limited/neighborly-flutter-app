import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_sizedbox.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/get_join_group_request_bloc.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/handle_join_request_bloc.dart';
import '../../data/model/group_join_request_model.dart';

class ManageJoinRequestScreen extends StatefulWidget {
  final String communityId;
  const ManageJoinRequestScreen({super.key, required this.communityId});

  @override
  State<ManageJoinRequestScreen> createState() =>
      _ManageJoinRequestScreenState();
}

class _ManageJoinRequestScreenState extends State<ManageJoinRequestScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetJoinGroupRequestBloc>(context)
        .add(FeatchJoinGroupRequestEvent(
      communityId: widget.communityId,
    ));
  }

  Future<void> _onRefresh() async {
    print('refresh call');
    BlocProvider.of<GetJoinGroupRequestBloc>(context)
        .add(FeatchJoinGroupRequestEvent(
      communityId: widget.communityId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "Manage Join Request",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocConsumer<GetJoinGroupRequestBloc, GetJoinGroupRequestState>(
          listener: (context, state) {
            if (state is GetJoinGroupRequestFailureState) {
              showSnackBar(context: context, message: state.error);
            }
          },
          builder: (context, state) {
            if (state is GetJoinGroupRequestLoadingState) {
              return CustomCircularIndicator();
            }
            if (state is GetJoinGroupRequestSuccessState &&
                state.communities.isEmpty) {
              return noPendingRequestScreen();
            }
            if (state is GetJoinGroupRequestSuccessState &&
                state.communities.isNotEmpty) {
              List<GroupJoinRequestModel> requestList = state.communities;
              return ListView.builder(
                itemCount: requestList.length,
                itemBuilder: (context, index) {
                  final user = requestList[index];

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // User Profile Picture
                        CircleAvatar(
                          radius: 24,
                          onBackgroundImageError: (_, __) => SizedBox(),
                          backgroundImage:
                              CachedNetworkImageProvider(user.userpic),
                        ),
                        SizedBox(width: 8),

                        // User Name
                        Expanded(
                          child: Text(
                            user.username,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Accept Button
                        ElevatedButton(
                          onPressed: () {
                            _showAcceptBottomSheet(
                              context,
                              user.username,
                              user.id,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Accept",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        CustomSizedBox(
                          width: 4,
                        ),

                        InkWell(
                          onTap: () {
                            _showRejectBottomSheet(
                              context,
                              user.username,
                              user.id,
                            );
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.black54,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }

  // Bottom Sheet for Accepting
  void _showAcceptBottomSheet(
    BuildContext context,
    String userName,
    String requestId,
  ) {
    showModalBottomSheet(
      showDragHandle: true,
      useRootNavigator: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BlocConsumer<HandleJoinRequestBloc, HandleJoinRequestState>(
          listener: (context, state) {
            if (state is HandleJoinRequestSuccessState) {
              BlocProvider.of<GetJoinGroupRequestBloc>(context).add(
                FeatchJoinGroupRequestEvent(
                  communityId: widget.communityId,
                ),
              );

              showSnackBar(
                context: context,
                message: "request has been accepted!",
              );
            } else if (state is HandleJoinRequestFailureState) {
              showSnackBar(context: context, message: "Something went wrong!");
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(text: "Are you sure you want to approve"),
                        const TextSpan(text: "  "),
                        TextSpan(
                          text: "$userName's",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(text: "  "),
                        const TextSpan(text: "request?"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(151, 212, 212, 247),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 44,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          BlocProvider.of<HandleJoinRequestBloc>(context).add(
                            HandleGroupJoinRequestEvent(
                              requestId: requestId,
                              communityId: widget.communityId,
                              status: "yes",
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 44,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: state is HandleJoinRequestLoadingState
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                "Accept",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Bottom Sheet for Rejecting
  void _showRejectBottomSheet(
    BuildContext context,
    String userName,
    String requestId,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return BlocConsumer<HandleJoinRequestBloc, HandleJoinRequestState>(
          listener: (context, state) {
            if (state is HandleJoinRequestSuccessState) {
              print("success state call");
              _onRefresh();

              showSnackBar(
                context: context,
                message: "request has been rejected!",
              );
            }
            if (state is HandleJoinRequestFailureState) {
              showSnackBar(context: context, message: "Something went wrong!");
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(text: "Are you sure you want to reject"),
                        const TextSpan(text: "  "),
                        TextSpan(
                          text: "$userName's",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(text: "  "),
                        const TextSpan(text: "request?"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(151, 212, 212, 247),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 44,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          BlocProvider.of<HandleJoinRequestBloc>(context).add(
                            HandleGroupJoinRequestEvent(
                              requestId: requestId,
                              communityId: widget.communityId,
                              status: "no",
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.redColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 44,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: state is HandleJoinRequestLoadingState
                            ? const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              )
                            : Text(
                                "Reject",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget noPendingRequestScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/no-request-pending-image.svg',
          ),
          CustomSizedBox(
            height: 12,
          ),
          Text(
            'No Pending Requests',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          CustomSizedBox(
            height: 4,
          ),
          Text(
            'You\'re all caught up! New join requests will appear here.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          )
        ],
      ),
    );
  }
}
