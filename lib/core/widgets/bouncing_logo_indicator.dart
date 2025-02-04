import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

dynamic BouncingLogoIndicator({required String logo}) {
  return CircularProgressIndicator(
    color: AppColors.primaryColor,
  );
}
