import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsEmptyWidget extends StatelessWidget {
  const NotificationsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/notification_empty.svg',
            width: MediaQuery.of(context).size.width * 0.60,
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.no_new_notifications,
            // 'No New Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!
                .there_are_currently_no_notifications_to_display,
            // 'There are currently no notifications to display.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
