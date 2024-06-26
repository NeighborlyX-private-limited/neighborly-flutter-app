import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      initialLabelIndex: currentIndex,
      minHeight: 35,
      minWidth: 38,
      activeBgColor: [Color(0xff635BFF)],
      inactiveBgColor: const Color(0xffC5C2FF),
      dividerColor: Colors.blue,
      cornerRadius: 32.0,
      customWidgets: [
        SvgPicture.asset(
          widget.imagePath1,
          width: 35,
          height: 35,
        ),
        Image.asset(
          widget.imagePath2,
          width: 30,
          height: 30,
        ),
      ],
      onToggle: (index) {
        setState(() {
          currentIndex = index!; // Update the current index
        });
        widget.onToggle(index == 0); // Trigger the callback
      },
    );
  }
}
