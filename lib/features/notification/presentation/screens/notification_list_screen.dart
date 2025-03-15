import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/somthing_went_wrong.dart';
import 'package:neighborly_flutter_app/features/notification/data/data_sources/notification_remote_data_source/notification_remote_data_source_impl.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/bloc/notification_list_cubit.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/bloc/notification_list_state.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/widgets/notification_empty_widget.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/widgets/notification_tile_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  NotificationListScreenState createState() => NotificationListScreenState();
}

class NotificationListScreenState extends State<NotificationListScreen> {
  final ScrollController _scrollController = ScrollController();
  late NotificationListCubit notificationsListCubit;
// INIT STATE
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

// READ ALL NOTIFICATION
  void _readAllNotification(var ids) async {
    await updateNotificationStatus(ids);
  }

  // SCREEN REFRESH CALL
  Future<void> _onRefresh() async {
    notificationsListCubit.init();
  }

  // DISPOSE
  @override
  void dispose() {
    _scrollController.dispose();
    notificationsListCubit.setPagetoDefault();
    super.dispose();
  }

// BUILD
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        // APP BAR
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: Text(AppLocalizations.of(context)!.notifications),
          centerTitle: true,
        ),
        // BODY
        body: BlocBuilder<NotificationListCubit, NotificationListState>(
          builder: (context, state) {
            // LOADING STATE
            if (state.status == Status.loading) {
              return CustomCircularIndicator();
            }

            // FAILURE STATE
            else if (state.status == Status.failure) {
              return SomethingWentWrong(
                imagePath: 'assets/something_went_wrong.svg',
                title: AppLocalizations.of(context)!.aaah_something_went_wrong,
                message: AppLocalizations.of(context)!
                    .we_couldnot_fetch_your_notification_Please_try_starting_it_again,
                buttonText: AppLocalizations.of(context)!.retry,
                onButtonPressed: () {
                  _onRefresh();
                },
              );
            }

            // SUCCESS STATE WITH ZERO NOTIFICATION MESSAGE
            if (state.status == Status.success && state.notifications.isEmpty) {
              return NotificationsEmptyWidget();
            }
            // SUCCESS STATE WITH SOME NOTIFICATION MESSAGE
            else {
              // GET ALL UNREAD NOTIFICATION ID'S
              List<String> unreadIds = state.notifications
                  .where((item) => item.status == 'unread')
                  .map((item) => item.id)
                  .toList();
              _readAllNotification(unreadIds);

              return ListView.builder(
                controller: _scrollController,
                itemCount: state.notifications.length +
                    (notificationsListCubit.hasMoreNotifications ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.notifications.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
