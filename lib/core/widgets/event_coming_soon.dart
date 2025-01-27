import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class CommingSoonScreen extends StatelessWidget {
  const CommingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          automaticallyImplyLeading: false,
          title: SvgPicture.asset(
            'assets/logo.svg',
            width: 30,
            height: 34,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/event-coming-soon.svg',
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                '🎉 Events Feature Launching Soon!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'We\'re working hard to bring exciting events to your neighborhood! Stay tuned for updates—you won\'t want to miss it.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  elevation: 0,
                ),
                child: Text(
                  '✨ Notify Me',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
