import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_sizedbox.dart';
import 'package:neighborly_flutter_app/features/communities/presentation/bloc/bloc/get_join_group_request_bloc.dart';

import '../../data/model/group_join_request_model.dart';

class ManageJoinRequestScreen extends StatefulWidget {
  final String communityId;
  const ManageJoinRequestScreen({super.key, required this.communityId});

  @override
  State<ManageJoinRequestScreen> createState() =>
      _ManageJoinRequestScreenState();
}

class _ManageJoinRequestScreenState extends State<ManageJoinRequestScreen> {
  // Sample user data
  final List<Map<String, String>> list = [
    {
      "name": "John Doe John Doe John Doe",
      "image": "https://via.placeholder.com/50"
    },
    {"name": "Emma Watson", "image": "https://via.placeholder.com/50"},
    {"name": "David Smith", "image": "https://via.placeholder.com/50"},
    {"name": "Sophia Brown", "image": "https://via.placeholder.com/50"},
  ];

  Widget noPendingRequestScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/no-request-pending-image.svg',
            // 'assets/private-lock-icon.svg',
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

  @override
  void initState() {
    super.initState();

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
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.2),
                offset: Offset(0, 4),
                blurRadius: 5,
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
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
      body: BlocConsumer<GetJoinGroupRequestBloc, GetJoinGroupRequestState>(
          listener: (context, state) {
        if (state is GetJoinGroupRequestFailureState) {}
        if (state is GetJoinGroupRequestSuccessState) {}
      }, builder: (context, state) {
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
            // itemCount: requestList.length,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final user = list[index];
              // final user = requestList[index];

              return Container(
                // margin: EdgeInsets.only(bottom: 12),
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
                      // backgroundImage: NetworkImage(user.ProfilePic),
                      radius: 24,
                    ),
                    SizedBox(width: 8),

                    // User Name
                    Expanded(
                      child: Text(
                        'user.username',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Accept Button
                    ElevatedButton(
                      onPressed: () {
                        _showAcceptBottomSheet(context, 'user.username');
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
                    // Reject Button (Cross Icon)
                    InkWell(
                      onTap: () {
                        _showRejectBottomSheet(context, 'user.username');
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
      }),
    );
  }

  // Bottom Sheet for Accepting
  void _showAcceptBottomSheet(BuildContext context, String userName) {
    showModalBottomSheet(
      showDragHandle: true,
      useRootNavigator: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _bottomSheetContent(
          context,
          "Are you sure you want to approve",
          "$userName's",
          AppColors.primaryColor,
          "Accept",
          () {
            // Handle accept logic
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$userName has been accepted!")),
            );
          },
        );
      },
    );
  }

  // Bottom Sheet for Rejecting
  void _showRejectBottomSheet(BuildContext context, String userName) {
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
        return _bottomSheetContent(
          context,
          "Are you sure you want to reject",
          "$userName's ",
          AppColors.redColor,
          "Reject",
          () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$userName's request has been rejected!")),
            );
          },
        );
      },
    );
  }

  // Common Bottom Sheet Widget
  Widget _bottomSheetContent(
    BuildContext context,
    String message,
    String userName,
    Color buttonColor,
    String btnName,
    VoidCallback onConfirm,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ), // Default text style
              children: [
                TextSpan(text: message),
                const TextSpan(text: "  "),
                TextSpan(
                  text: userName,
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showSnackBar(
                      context: context, message: 'Hy How\'s this snackbar');
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(151, 212, 212, 247),
                  padding: EdgeInsets.symmetric(horizontal: 44, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: buttonColor,
                  padding: EdgeInsets.symmetric(horizontal: 44, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  btnName,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
