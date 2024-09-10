import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';

class ChatEmptyWidget extends StatelessWidget {
  const ChatEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBackgroundColor,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            //
            SvgPicture.asset(
              'assets/chat_welcome.svg',
              width: MediaQuery.of(context).size.width * 0.60,
              // height: 84,
            ),
            const SizedBox(height: 20),
            //
            //
            Text(
              'Welcome to chat!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            //
            //
            Text(
              'Engage by joining communities or sending direct messages.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            //
            //

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/groups/search');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff635BFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        50), // Ajuste o raio conforme necessário
                  ),
                  padding: EdgeInsets.all(15)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.diversity_3,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Explore communities',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
