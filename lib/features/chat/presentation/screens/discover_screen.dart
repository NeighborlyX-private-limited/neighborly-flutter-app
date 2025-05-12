import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/app_images.dart';
import 'package:neighborly_flutter_app/core/routes/routes.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/features/chat/presentation/bloc/bloc/nearby_user_bloc.dart';

import '../../../../core/widgets/svg_icon.dart';
import '../../../refer_and_earn/data/model/reward_model.dart';
import '../../data/model/nearby_user_model.dart';
import '../bloc/bloc/interest_bloc.dart';
import '../bloc/dm/create_dm_bloc.dart';

// class DiscoverScreen extends StatefulWidget {
//   const DiscoverScreen({super.key});

//   @override
//   DiscoverScreenState createState() => DiscoverScreenState();
// }

// class DiscoverScreenState extends State<DiscoverScreen> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<NearbyUserBloc>().add(FeatchNearbyUserEvent());
//     });
//   }

//   Map<String, bool> showMoreMap = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Connect with Neighbours"),
//       ),
//       body: BlocConsumer<NearbyUserBloc, NearbyUserState>(
//         listener: (BuildContext context, state) {},
//         builder: (BuildContext context, state) {
//           if (state is NearbyUserLoadingState) {
//             return CustomCircularIndicator();
//           }
//           if (state is NearbyUserSuccessState) {
//             print('state value: ${state.nearbyUser.length}');

//             return ListView.builder(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               itemCount: state.nearbyUser.length,
//               // itemCount: users.length,
//               itemBuilder: (context, index) {
//                 var user = state.nearbyUser[index];
//                 bool showMore = showMoreMap[user.username] ?? false;
//                 int maxTags = 3;

//                 return Container(
//                   margin: EdgeInsets.only(bottom: 12),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: AppColors.lightGreyColor,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // User Details
//                       ListTile(
//                           leading: CircleAvatar(
//                             backgroundImage: NetworkImage(user.picture),
//                             radius: 24,
//                           ),
//                           title: Text(
//                             user.username,
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Text(
//                             '${user.distance.toInt().toString()} KM (Approx.)',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                           trailing: BlocConsumer<CreateDmBloc, CreateDmState>(
//                             listener: (context, state) {
//                               if (state is CreateDmSuccessState) {
//                                 // print('success state${user.}');
//                                 context.push(
//                                   '/chat-private/${state.chatId}',
//                                   extra: {
//                                     'profilePic': user.picture,
//                                     'userName': user.username,
//                                   },
//                                 );

//                                 context.push('/chat-private/${state.chatId}');
//                               }
//                               if (state is CreateDmFailureState) {
//                                 showSnackBar(
//                                   context: context,
//                                   message: state.error,
//                                 );
//                               }
//                               // TODO: implement listener
//                             },
//                             builder: (context, state) {
//                               if (state is CreateDmLoadingState) {
//                                 return SvgPicture.asset(AppImages.blueChatIcon);
//                               }

//                               return GestureDetector(
//                                 onTap: () {
//                                   BlocProvider.of<CreateDmBloc>(context).add(
//                                     CreateNewDmEvent(userId: user.id),
//                                   );
//                                   // context.go('/chat-private/:chatId');
//                                   // /chat-private/:chatId
//                                 },
//                                 child: SvgPicture.asset(AppImages.blueChatIcon),
//                               );
//                             },
//                           )),

//                       SizedBox(height: 8),

//                       // Interests
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 12,
//                           right: 12,
//                           bottom: 12,
//                         ),
//                         child: Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: [
//                             ...user.interests
//                                 .take(
//                                     showMore ? user.interests.length : maxTags)
//                                 .map((interest) => InterestChip(interest)),
//                             if (user.interests.length > maxTags)
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     showMoreMap[user.username] = !showMore;
//                                   });
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 12, vertical: 6),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     border: Border.all(
//                                         color: AppColors.primaryColor),
//                                   ),
//                                   child: Text(
//                                     showMore ? "Show less" : "Show more",
//                                     style: TextStyle(
//                                       color: AppColors.primaryColor,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//           return SizedBox();
//         },
//       ),
//     );
//   }
// }
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  DiscoverScreenState createState() => DiscoverScreenState();
}

class DiscoverScreenState extends State<DiscoverScreen> {
  Map<String, bool> showMoreMap = {};
  NearbyUserModel? selectedUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NearbyUserBloc>().add(FeatchNearbyUserEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateDmBloc, CreateDmState>(
      listener: (context, state) {
        if (state is CreateDmSuccessState && selectedUser != null) {
          context.push(
            '/chat-private/${state.chatId}',
            extra: {
              'profilePic': selectedUser!.picture,
              'userName': selectedUser!.username,
            },
          );
        } else if (state is CreateDmFailureState) {
          showSnackBar(context: context, message: state.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Connect with Neighbours"),
        ),
        body: BlocBuilder<NearbyUserBloc, NearbyUserState>(
          builder: (BuildContext context, state) {
            if (state is NearbyUserLoadingState) {
              return CustomCircularIndicator();
            }

            if (state is NearbyUserSuccessState) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.nearbyUser.length,
                itemBuilder: (context, index) {
                  var user = state.nearbyUser[index];
                  bool showMore = showMoreMap[user.username] ?? false;
                  int maxTags = 3;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.lightGreyColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Info
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.picture),
                            radius: 24,
                          ),
                          title: Text(
                            user.username,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${user.distance.toInt()} KM (Approx.)',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedUser = user;
                              });
                              context
                                  .read<CreateDmBloc>()
                                  .add(CreateNewDmEvent(userId: user.id));
                            },
                            child: SvgPicture.asset(AppImages.blueChatIcon),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Interests
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            bottom: 12,
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ...user.interests
                                  .take(showMore
                                      ? user.interests.length
                                      : maxTags)
                                  .map((interest) => InterestChip(interest)),
                              if (user.interests.length > maxTags)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showMoreMap[user.username] = !showMore;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: AppColors.primaryColor),
                                    ),
                                    child: Text(
                                      showMore ? "Show less" : "Show more",
                                      style: const TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// Widget for Interest Chips
class InterestChip extends StatelessWidget {
  final String interest;
  const InterestChip(this.interest, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyColor),
      ),
      child: Text(
        interest,
        style: TextStyle(
          color: AppColors.greyColor.withOpacity(0.7),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
