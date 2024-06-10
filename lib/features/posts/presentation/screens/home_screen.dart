import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/post2_widget.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/post3_widget.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/post_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xFFF5F5FF),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Image.asset(
                height: 100,
                width: 90,
                'assets/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  'assets/alarm.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          body: const Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PostWidget(),
                      SizedBox(
                        height: 12,
                      ),
                      Post2Widget(),
                      SizedBox(
                        height: 12,
                      ),
                      Post3Widget(),
                      SizedBox(
                        height: 12,
                      ),
                      PostWidget(),
                      SizedBox(
                        height: 12,
                      ),
                      Post2Widget(),
                      SizedBox(
                        height: 12,
                      ),
                      Post3Widget(),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
