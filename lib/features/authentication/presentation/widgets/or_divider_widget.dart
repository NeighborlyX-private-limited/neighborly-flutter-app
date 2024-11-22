import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class OrDividerWidget extends StatelessWidget {
  const OrDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: const Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.greyColor,
              thickness: 1,
            ),
          ),
          SizedBox(width: 10),
          Text(
            "or",
            style: TextStyle(
              color: AppColors.greyColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Divider(
              color: AppColors.greyColor,
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
