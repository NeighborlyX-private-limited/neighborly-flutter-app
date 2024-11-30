import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomToggleSwitch extends StatefulWidget {
  final String imagePath1;
  final String imagePath2;
  final Function(bool) onToggle;

  const CustomToggleSwitch({
    super.key,
    required this.imagePath1,
    required this.imagePath2,
    required this.onToggle,
  });

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  int currentIndex = 0;

  setCurrentIndex() {
    setState(() {
      final bool isLocationOn = ShardPrefHelper.getIsLocationOn();
      currentIndex = isLocationOn ? 1 : 0;
    });
  }

  @override
  void initState() {
    super.initState();
    setCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    print("togggle click with index: $currentIndex");
    return ToggleSwitch(
      initialLabelIndex: currentIndex,
      minHeight: 35,
      minWidth: 38,
      activeBgColor: [AppColors.primaryColor],
      inactiveBgColor: AppColors.whiteColor,
      dividerColor: AppColors.primaryColor,
      cornerRadius: 32.0,
      customWidgets: [
        SvgPicture.asset(
          widget.imagePath1,
          width: 35,
          height: 35,
        ),
        SvgPicture.asset(
          widget.imagePath2,
          width: 35,
          height: 35,
        ),
      ],
      onToggle: (index) {
        if (mounted) {
          setState(
            () {
              if (index == 1) {
                ShardPrefHelper.setIsLocationOn(true);
                setCurrentIndex();
              } else {
                ShardPrefHelper.setIsLocationOn(false);
                setCurrentIndex();
              }
            },
          );
        }
        widget.onToggle(index == 0);
      },
    );
  }
}
