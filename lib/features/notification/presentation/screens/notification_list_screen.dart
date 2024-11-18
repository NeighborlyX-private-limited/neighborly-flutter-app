// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';

// // import '../../../../core/constants/status.dart';
// // import '../../../../core/theme/colors.dart';
// // import '../bloc/notification_list_cubit.dart';
// // import '../widgets/notification_tile_widget.dart';
// // import 'notification_empty_widget.dart';

// // class NotificationListScreen extends StatefulWidget {
// //   const NotificationListScreen({super.key});

// //   @override
// //   State<NotificationListScreen> createState() => _NotificationListScreenState();
// // }

// // class _NotificationListScreenState extends State<NotificationListScreen> {
// //   late NotificationListCubit notificationsListCubit;
// //   final ScrollController _scrollController = ScrollController();
// //   bool _isLoadingMore = false;
// //   bool _shouldScrollToBottom = true;
// //   double _previousScrollOffset = 0.0;

// //   @override
// //   void initState() {
// //     super.initState();
// //     notificationsListCubit = BlocProvider.of<NotificationListCubit>(context);
// //     notificationsListCubit.init();
// //     _scrollController.addListener(() {
// //       if (_scrollController.position.pixels <= 100 && !_isLoadingMore) {
// //         _loadMoreMessages();
// //       }
// //     });
// //   }

// //   void _scrollToBottom() {
// //     if (_scrollController.hasClients && _shouldScrollToBottom) {
// //       Future.delayed(Duration(milliseconds: 300), () {
// //         _scrollController.position.jumpTo(_previousScrollOffset);
// //         print("Scrolling to bottom: $_previousScrollOffset");
// //       });
// //     }
// //   }

// //   Future<void> _onRefresh() async {
// //     notificationsListCubit = BlocProvider.of<NotificationListCubit>(context);
// //     notificationsListCubit.init();
// //     _scrollController.addListener(() {
// //       if (_scrollController.position.pixels <= 100 && !_isLoadingMore) {
// //         _loadMoreMessages();
// //       }
// //     });
// //   }

// //   void _scrollToEnd() {
// //     if (_scrollController.hasClients) {
// //       Future.delayed(Duration(milliseconds: 300), () {
// //         _scrollController.animateTo(
// //           _scrollController.position.maxScrollExtent,
// //           duration: Duration(milliseconds: 300),
// //           curve: Curves.easeOut,
// //         );
// //         setState(() {
// //           _previousScrollOffset = _scrollController.position.maxScrollExtent;
// //         });
// //       });
// //     }
// //   }

// //   Future<void> _loadMoreMessages() async {
// //     double currentScrollOffset = _scrollController.offset;
// //     setState(() {
// //       _isLoadingMore = true;
// //       _shouldScrollToBottom = false;
// //     });
// //     await context.read<NotificationListCubit>().fetchOlderNotification();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _scrollController.jumpTo(_previousScrollOffset + 500);
// //     });
// //     setState(() {
// //       _isLoadingMore = false;
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     notificationsListCubit.setPagetoDefault();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return RefreshIndicator(
// //       onRefresh: _onRefresh,
// //       child: Scaffold(
// //         appBar: AppBar(
// //           leading: GestureDetector(
// //             child: Icon(
// //               Icons.arrow_back_ios,
// //               color: Colors.black,
// //             ),
// //             onTap: () {
// //               // getUnreadNotificationCount();
// //               Navigator.of(context).pop();
// //             },
// //           ),
// //           title: Text('Notifications'),
// //         ),
// //         body: BlocConsumer<NotificationListCubit, NotificationListState>(
// //           listener: (context, state) {
// //             switch (state.status) {
// //               case Status.loading:
// //                 break;
// //               case Status.failure:
// //                 print('ERROR ${state.failure?.message}');
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   SnackBar(
// //                     content:
// //                         Text('Something went wrong! ${state.failure?.message}'),
// //                   ),
// //                 );
// //                 break;
// //               case Status.success:
// //                 break;
// //               case Status.initial:
// //                 break;
// //             }
// //             if (state.status == Status.success && !_isLoadingMore) {
// //               _shouldScrollToBottom = true;
// //               //_scrollToBottom();
// //             }
// //             if (state.status == Status.success && state.page == 1) {
// //               Future.delayed(Duration(milliseconds: 100), () {
// //                 if (_scrollController.hasClients) {
// //                   _scrollToEnd();
// //                 }
// //               });
// //             }
// //           },
// //           builder: (context, state) {
// //             return BlocBuilder<NotificationListCubit, NotificationListState>(
// //               bloc: notificationsListCubit,
// //               builder: (context, state) {
// //                 if (state.status == Status.loading) {
// //                   return Center(
// //                     child: SizedBox(
// //                       height: 40,
// //                       width: 40,
// //                       child: CircularProgressIndicator(
// //                         color: AppColors.primaryColor,
// //                       ),
// //                     ),
// //                   );
// //                 }

// //                 if (state.status != Status.loading &&
// //                     state.notifications.isEmpty) {
// //                   return Center(
// //                     child: NotificationsEmptyWidget(),
// //                   );
// //                 }

// //                 return Container(
// //                   padding: EdgeInsets.only(top: 15),
// //                   width: double.infinity,
// //                   color: Colors.white,
// //                   child: ListView.builder(
// //                     controller: _scrollController,
// //                     itemCount: state.notifications.length,
// //                     itemBuilder: (context, index) {
// //                       return NotificationTileWidget(
// //                           notification: state.notifications[index]);
// //                     },
// //                   ),
// //                 );
// //               },
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/constants/status.dart';
// import '../../../../core/theme/colors.dart';
// import '../bloc/notification_list_cubit.dart';
// import '../widgets/notification_tile_widget.dart';
// import 'notification_empty_widget.dart';

// class NotificationListScreen extends StatefulWidget {
//   const NotificationListScreen({super.key});

//   @override
//   State<NotificationListScreen> createState() => _NotificationListScreenState();
// }

// class _NotificationListScreenState extends State<NotificationListScreen> {
//   late NotificationListCubit notificationsListCubit;
//   final ScrollController _scrollController = ScrollController();
//   bool _isLoadingMore = false;

//   @override
//   void initState() {
//     super.initState();
//     notificationsListCubit = BlocProvider.of<NotificationListCubit>(context);
//     notificationsListCubit.init();
//     _scrollController.addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 100 &&
//         !_isLoadingMore) {
//       _loadMoreMessages();
//     }
//   }

//   Future<void> _loadMoreMessages() async {
//     setState(() {
//       _isLoadingMore = true;
//     });
//     await notificationsListCubit.fetchOlderNotification();
//     setState(() {
//       _isLoadingMore = false;
//     });
//   }

//   Future<void> _onRefresh() async {
//     notificationsListCubit.init();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     notificationsListCubit.setPagetoDefault();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: _onRefresh,
//       child: Scaffold(
//         appBar: AppBar(
//           leading: GestureDetector(
//             child: Icon(Icons.arrow_back_ios, color: Colors.black),
//             onTap: () => Navigator.of(context).pop(),
//           ),
//           title: Text('Notifications'),
//         ),
//         body: BlocConsumer<NotificationListCubit, NotificationListState>(
//           listener: (context, state) {
//             if (state.status == Status.failure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                     content: Text(
//                         'Something went wrong! ${state.failure?.message}')),
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state.status == Status.loading && state.notifications.isEmpty) {
//               return Center(
//                   child:
//                       CircularProgressIndicator(color: AppColors.primaryColor));
//             }

//             if (state.notifications.isEmpty) {
//               return Center(child: NotificationsEmptyWidget());
//             }

//             return ListView.builder(
//               controller: _scrollController,
//               itemCount: state.notifications.length + (_isLoadingMore ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == state.notifications.length) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 return NotificationTileWidget(
//                   notification: state.notifications[index],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:neighborly_flutter_app/features/notification/presentation/bloc/notification_list_cubit.dart';
// import 'package:neighborly_flutter_app/features/notification/presentation/bloc/notification_list_state.dart';
// import 'package:neighborly_flutter_app/features/notification/presentation/widgets/notification_tile_widget.dart';

// class NotificationListScreen extends StatefulWidget {
//   const NotificationListScreen({super.key});

//   @override
//   _NotificationListScreenState createState() => _NotificationListScreenState();
// }

// class _NotificationListScreenState extends State<NotificationListScreen> {
//   late NotificationListCubit notificationsListCubit;
//   final ScrollController _scrollController = ScrollController();
//   bool _isLoadingMore = false;

//   @override
//   void initState() {
//     super.initState();
//     notificationsListCubit = BlocProvider.of<NotificationListCubit>(context);
//     notificationsListCubit.init();
//     _scrollController.addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 100 &&
//         !_isLoadingMore &&
//         notificationsListCubit.hasMoreNotifications) {
//       _loadMoreMessages();
//     }
//   }

//   Future<void> _loadMoreMessages() async {
//     setState(() {
//       _isLoadingMore = true;
//     });
//     await notificationsListCubit.fetchOlderNotification();
//     setState(() {
//       _isLoadingMore = false;
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     notificationsListCubit.setPagetoDefault();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Notifications"),
//       ),
//       body: BlocBuilder<NotificationListCubit, NotificationListState>(
//         builder: (context, state) {
//           if (state.status == Status.loading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state.status == Status.failure) {
//             return Center(child: Text("Failed to load notifications"));
//           } else {
//             return ListView.builder(
//               controller: _scrollController,
//               itemCount: state.notifications.length + (_isLoadingMore ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == state.notifications.length) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 return NotificationTileWidget(
//                   notification: state.notifications[index],
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/somthing_went_wrong.dart';
import 'package:neighborly_flutter_app/features/notification/data/data_sources/notification_remote_data_source/notification_remote_data_source_impl.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/bloc/notification_list_cubit.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/bloc/notification_list_state.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/screens/notification_empty_widget.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/widgets/notification_tile_widget.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late NotificationListCubit notificationsListCubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notificationsListCubit = BlocProvider.of<NotificationListCubit>(context);
    notificationsListCubit.init();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        notificationsListCubit.hasMoreNotifications &&
        notificationsListCubit.state.status != Status.loading) {
      notificationsListCubit.fetchOlderNotification();
    }
  }

  void _fetchProfile() {
    notificationsListCubit = BlocProvider.of<NotificationListCubit>(context);
    notificationsListCubit.init();
    //_scrollController.addListener(_scrollListener);
  }

  void _readAllNotification(var ids) async {
    await updateNotificationStatus(ids);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    notificationsListCubit.setPagetoDefault();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    notificationsListCubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
        ),
        body: BlocBuilder<NotificationListCubit, NotificationListState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return Center(
                child: BouncingLogoIndicator(
                  logo: 'images/logo.svg',
                ),
              );

              // return Center(child: CircularProgressIndicator());
            } else if (state.status == Status.failure) {
              return SomethingWentWrong(
                imagePath: 'assets/something_went_wrong.svg',
                title: 'Aaah! Something went wrong',
                message:
                    "We couldn't fetch your notification.\nPlease try starting it again",
                buttonText: 'Retry',
                onButtonPressed: () {
                  _fetchProfile();

                  print("Retry pressed");
                },
              );
            }
            if (state.status != Status.loading && state.notifications.isEmpty) {
              return Center(
                child: NotificationsEmptyWidget(),
              );
            } else {
              //get all the unread notification id
              List<String> unreadIds = state.notifications
                  .where((item) => item.status == 'unread')
                  .map((item) => item.id)
                  .toList();
              _readAllNotification(unreadIds);
              //getUnreadNotificationCount();
              print(unreadIds);
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.notifications.length +
                    (notificationsListCubit.hasMoreNotifications ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.notifications.length) {
                    // This is the loader at the bottom of the list
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      // child: Center(
                      //   child: BouncingLogoIndicator(
                      //     logo: 'images/logo.svg',
                      //   ),
                      // ),
                      // child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return NotificationTileWidget(
                    notification: state.notifications[index],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
