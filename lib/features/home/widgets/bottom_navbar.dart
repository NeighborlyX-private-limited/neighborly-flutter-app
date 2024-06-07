import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFF5F5FF),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Image.asset(
                'assets/home.png',
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                'Home',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
            Column(children: [
              Image.asset(
                'assets/events.png',
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                'Events',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
            Image.asset(
              'assets/add.png',
              fit: BoxFit.contain,
            ),
            Column(children: [
              Image.asset(
                'assets/groups.png',
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                'Groups',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
            Column(children: [
              Image.asset(
                'assets/person.png',
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                'profile',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ])
          ],
        ));
  }
}
