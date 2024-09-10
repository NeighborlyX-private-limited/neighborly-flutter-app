import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventEmptyMy extends StatelessWidget {
  const EventEmptyMy({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        SvgPicture.asset('assets/event_empty.svg'),

        Text(
          'You have not created an event yet.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 5),
        //
        //
        Text(
          'Create one using the +',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        //
        //
      ],
    );
  }
}
