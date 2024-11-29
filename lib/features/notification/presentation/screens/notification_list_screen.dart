import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/somthing_went_wrong.dart';
import 'package:neighborly_flutter_app/features/notification/data/data_sources/notification_remote_data_source/notification_remote_data_source_impl.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/bloc/notification_list_cubit.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/bloc/notification_list_state.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/screens/notification_empty_widget.dart';
import 'package:neighborly_flutter_app/features/notification/presentation/widgets/notification_tile_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  NotificationListScreenState createState() => NotificationListScreenState();
}

class NotificationListScreenState extends State<NotificationListScreen> {
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
          title: Text(AppLocalizations.of(context)!.notifications),
        ),
        body: BlocBuilder<NotificationListCubit, NotificationListState>(
          builder: (context, state) {
            ///loading state
            if (state.status == Status.loading) {
              return Center(
                child: BouncingLogoIndicator(
                  logo: 'images/logo.svg',
                ),
              );
            }

            ///failure state
            else if (state.status == Status.failure) {
              return SomethingWentWrong(
                imagePath: 'assets/something_went_wrong.svg',
                title: AppLocalizations.of(context)!.aaah_something_went_wrong,
                message: AppLocalizations.of(context)!
                    .we_couldnot_fetch_your_notification_Please_try_starting_it_again,
                buttonText: AppLocalizations.of(context)!.retry,
                onButtonPressed: () {
                  _fetchProfile();
                },
              );
            }

            ///notification success state
            ///zero notification
            if (state.status != Status.loading && state.notifications.isEmpty) {
              return Center(
                child: NotificationsEmptyWidget(),
              );
            } else {
              ///get all the unread notification id
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
