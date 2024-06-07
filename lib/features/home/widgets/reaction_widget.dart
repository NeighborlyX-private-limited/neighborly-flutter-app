import 'package:flutter/material.dart';

class ReactionWidget extends StatelessWidget {
  final bool second;
  final bool third;
  const ReactionWidget({super.key, required this.second, required this.third});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            second
                ? Image.asset(
                    'assets/react1.png',
                    width: 24,
                    height: 24,
                  )
                : Image.asset(
                    'assets/react5.png',
                    width: 24,
                    height: 24,
                  ),
            const SizedBox(
              width: 3,
            ),
            Text(
              '09',
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        Row(
          children: [
            third
                ? Image.asset(
                    'assets/react2.png',
                    width: 24,
                    height: 24,
                  )
                : Image.asset(
                    'assets/react6.png',
                    width: 24,
                    height: 24,
                  ),
            const SizedBox(
              width: 3,
            ),
            Text(
              '04',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/react3.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              '02',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/react4.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              '02',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        )
      ],
    );
  }
}
