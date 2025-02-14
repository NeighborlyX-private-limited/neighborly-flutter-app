import 'package:flutter/services.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

void setStatusBarColor({
  Color color = AppColors.whiteColor,
  Brightness iconBrightness = Brightness.dark,
}) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: color,
    statusBarIconBrightness: iconBrightness,
  ));
}
