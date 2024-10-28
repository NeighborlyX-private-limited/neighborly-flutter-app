import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            'No New Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'There are currently no notifications to display.',
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
