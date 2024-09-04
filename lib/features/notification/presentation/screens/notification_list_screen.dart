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

  @override
  void initState() {
    super.initState();
    notificationsListCubit = BlocProvider.of<NotificationListCubit>(context);
    notificationsListCubit.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          switch (state.status) {
            case Status.loading:
              break;
            case Status.failure:
              print('ERROR ${state.failure?.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Something went wrong! ${state.failure?.message}'),
                ),
              );
              break;
            case Status.success:
              break;
            case Status.initial:
              break;
          }
        },
        builder: (context, state) {
          //
          //
          return BlocBuilder<NotificationListCubit, NotificationListState>(
            bloc: notificationsListCubit,
            builder: (context, state) {
              if (state.status == Status.loading) {
                // return const NotificationMainSheemer();
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

              if (state.status != Status.loading && state.notifications.length == 0) {
                return Center(
                  child: NotificationsEmptyWidget(),
                );
              }

              return Container(
                padding: EdgeInsets.only(top: 15),
                width: double.infinity,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    return NotificationTileWidget(notification: state.notifications[index]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
