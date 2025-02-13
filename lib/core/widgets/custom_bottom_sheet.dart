import 'package:flutter/material.dart';
import '../theme/colors.dart';

Future<void> showCustomBottomSheet({
  required BuildContext context,
  required Widget content,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.whiteColor,
    barrierColor: AppColors.greyColor,
    showDragHandle: true,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: content,
      );
    },
  );
}
