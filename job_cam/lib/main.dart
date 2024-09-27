import 'package:flutter/material.dart';

import 'pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            primary: const Color.fromARGB(255, 98, 0, 255),
            seedColor: const Color.fromARGB(255, 136, 0, 241)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
