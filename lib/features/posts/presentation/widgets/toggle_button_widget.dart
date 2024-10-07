// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
// import 'package:toggle_switch/toggle_switch.dart';

// class CustomToggleSwitch extends StatefulWidget {
//   final String imagePath1;
//   final String imagePath2;
//   final Function(bool) onToggle;

//   const CustomToggleSwitch({
//     super.key,
//     required this.imagePath1,
//     required this.imagePath2,
//     required this.onToggle,
//   });

//   @override
//   State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
// }

// class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
//   int currentIndex = 0;
//   final bool _isLocationOn = ShardPrefHelper.getIsLocationOn();

//   @override
//   Widget build(BuildContext context) {
//     return ToggleSwitch(
//       initialLabelIndex: currentIndex,
//       minHeight: 35,
//       minWidth: 38,
//       activeBgColor: [Color(0xff635BFF)],
//       inactiveBgColor: const Color(0xffC5C2FF),
//       dividerColor: Colors.blue,
//       cornerRadius: 32.0,
//       customWidgets: [
//         SvgPicture.asset(
//           widget.imagePath1,
//           width: 35,
//           height: 35,
//         ),
//         SvgPicture.asset(
//           widget.imagePath2,
//           width: 35,
//           height: 35,
//         ),
//       ],
//       onToggle: (index) {
//         setState(() {
//           print('location on or not ${_isLocationOn}');
//           ShardPrefHelper.setIsLocationOn(!_isLocationOn);
//           print('location on ${ShardPrefHelper.getIsLocationOn()}');

//           currentIndex = index!; // Update the current index
//         });
//         widget.onToggle(index == 0); // Trigger the callback
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart'; // Assuming this is your shared pref helper
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
  void initState() {
    super.initState();
    _initializeToggleState();
  }

  /// Fetch the saved toggle state from SharedPreferences and update the UI
  void _initializeToggleState() async {
    bool isLocationOn = await ShardPrefHelper.getIsLocationOn();
    setState(() {
      currentIndex = isLocationOn
          ? 1
          : 0; // If saved state is true, set to 1 (second position), otherwise 0
    });
  }

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
        SvgPicture.asset(
          widget.imagePath2,
          width: 35,
          height: 35,
        ),
      ],
      onToggle: (index) async {
        setState(() {
          currentIndex =
              index!; // Update the current index based on the toggle state
        });

        // Determine whether the toggle is set to the second position (true) or first position (false)
        bool isLocationOn = index == 1;

        // Save the new state in SharedPreferences
        await ShardPrefHelper.setIsLocationOn(isLocationOn);

        print('Location state saved: $isLocationOn');

        // Trigger the callback with the updated state
        widget.onToggle(isLocationOn);
      },
    );
  }
}
