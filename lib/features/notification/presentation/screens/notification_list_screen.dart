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
//   bool _shouldScrollToBottom = true;
//   double _previousScrollOffset = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     notificationsListCubit = BlocProvider.of<NotificationListCubit>(context);
//     notificationsListCubit.init();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels <= 100 && !_isLoadingMore) {
//         _loadMoreMessages();
//       }
//     });
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients && _shouldScrollToBottom) {
//       Future.delayed(Duration(milliseconds: 300), () {
//         _scrollController.position.jumpTo(_previousScrollOffset);
//         print("Scrolling to bottom: $_previousScrollOffset");
//       });
//     }
//   }

//   Future<void> _onRefresh() async {
//     notificationsListCubit = BlocProvider.of<NotificationListCubit>(context);
//     notificationsListCubit.init();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels <= 100 && !_isLoadingMore) {
//         _loadMoreMessages();
//       }
//     });
//   }

//   void _scrollToEnd() {
//     if (_scrollController.hasClients) {
//       Future.delayed(Duration(milliseconds: 300), () {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//         setState(() {
//           _previousScrollOffset = _scrollController.position.maxScrollExtent;
//         });
//       });
//     }
//   }

//   Future<void> _loadMoreMessages() async {
//     double currentScrollOffset = _scrollController.offset;
//     setState(() {
//       _isLoadingMore = true;
//       _shouldScrollToBottom = false;
//     });
//     await context.read<NotificationListCubit>().fetchOlderNotification();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.jumpTo(_previousScrollOffset + 500);
//     });
//     setState(() {
//       _isLoadingMore = false;
//     });
//   }

//   @override
//   void dispose() {
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
//             child: Icon(
//               Icons.arrow_back_ios,
//               color: Colors.black,
//             ),
//             onTap: () {
//               // getUnreadNotificationCount();
//               Navigator.of(context).pop();
//             },
//           ),
//           title: Text('Notifications'),
//         ),
//         body: BlocConsumer<NotificationListCubit, NotificationListState>(
//           listener: (context, state) {
//             switch (state.status) {
//               case Status.loading:
//                 break;
//               case Status.failure:
//                 print('ERROR ${state.failure?.message}');
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content:
//                         Text('Something went wrong! ${state.failure?.message}'),
//                   ),
//                 );
//                 break;
//               case Status.success:
//                 break;
//               case Status.initial:
//                 break;
//             }
//             if (state.status == Status.success && !_isLoadingMore) {
//               _shouldScrollToBottom = true;
//               //_scrollToBottom();
//             }
//             if (state.status == Status.success && state.page == 1) {
//               Future.delayed(Duration(milliseconds: 100), () {
//                 if (_scrollController.hasClients) {
//                   _scrollToEnd();
//                 }
//               });
//             }
//           },
//           builder: (context, state) {
//             return BlocBuilder<NotificationListCubit, NotificationListState>(
//               bloc: notificationsListCubit,
//               builder: (context, state) {
//                 if (state.status == Status.loading) {
//                   return Center(
//                     child: SizedBox(
//                       height: 40,
//                       width: 40,
//                       child: CircularProgressIndicator(
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                   );
//                 }

//                 if (state.status != Status.loading &&
//                     state.notifications.isEmpty) {
//                   return Center(
//                     child: NotificationsEmptyWidget(),
//                   );
//                 }

//                 return Container(
//                   padding: EdgeInsets.only(top: 15),
//                   width: double.infinity,
//                   color: Colors.white,
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     itemCount: state.notifications.length,
//                     itemBuilder: (context, index) {
//                       return NotificationTileWidget(
//                           notification: state.notifications[index]);
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// -------------------------------------------------
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/notification_list_cubit.dart';
import '../widgets/notification_tile_widget.dart';
import 'notification_empty_widget.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late NotificationListCubit notificationsListCubit;
  ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _allNotificationsLoaded = false; // Track if all notifications are loaded

  @override
  void initState() {
    super.initState();
    notificationsListCubit = BlocProvider.of<NotificationListCubit>(context);
    notificationsListCubit.init(); // Initialize notifications
    _scrollController.addListener(() {
      // Load more messages when scrolling to the top
      if (_scrollController.position.pixels <= 100 &&
          !_isLoadingMore &&
          !_allNotificationsLoaded) {
        _loadMoreMessages();
      }
    });
  }

  Future<void> _onRefresh() async {
    notificationsListCubit.init(); // Reset notifications on refresh
    setState(() {
      _allNotificationsLoaded = false; // Reset loading flag
    });
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore || _allNotificationsLoaded) return;

    setState(() {
      _isLoadingMore = true; // Set loading state
    });

    // Fetch older notifications
    await notificationsListCubit.fetchOlderNotification();

    // Check if there are new notifications loaded
    final newNotifications = notificationsListCubit.state.notifications;

    // If no new notifications are available, set the loaded flag
    if (newNotifications.isEmpty) {
      setState(() {
        _allNotificationsLoaded = true; // No more notifications to load
      });
    }

    setState(() {
      _isLoadingMore = false; // Reset loading state
    });
  }

  @override
  void dispose() {
    notificationsListCubit.setPagetoDefault(); // Reset pagination on dispose
    _scrollController.dispose(); // Dispose of the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('Notifications'),
        ),
        body: BlocConsumer<NotificationListCubit, NotificationListState>(
          listener: (context, state) {
            if (state.status == Status.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Something went wrong! ${state.failure?.message}'),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == Status.loading && state.notifications.isEmpty) {
              return Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              );
            }

            if (state.notifications.isEmpty) {
              return Center(child: NotificationsEmptyWidget());
            }

            return Container(
              padding: EdgeInsets.only(top: 15),
              width: double.infinity,
              color: Colors.white,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.notifications.length +
                    (_isLoadingMore
                        ? 1
                        : 0), // Add loader at the end if loading
                itemBuilder: (context, index) {
                  if (index == state.notifications.length) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primaryColor));
                  }
                  return NotificationTileWidget(
                      notification: state.notifications[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
