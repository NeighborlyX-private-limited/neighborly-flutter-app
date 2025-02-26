import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_sizedbox.dart';

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
          CustomSizedBox(width: 10),
          Text(
            'OR',
            style: TextStyle(
              color: AppColors.greyColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          CustomSizedBox(width: 10),
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
