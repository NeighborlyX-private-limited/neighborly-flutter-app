import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class EventEmptyLocal extends StatelessWidget {
  const EventEmptyLocal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.lightBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No Event at moment',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          //
          //
          Text(
            'Good opportunity to create YOUR event',
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
