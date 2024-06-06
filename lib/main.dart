import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/routes/routes.dart';
import 'dependency_injection.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      title: 'Neighborly App',
      routerConfig: router,
    );
  }
}
