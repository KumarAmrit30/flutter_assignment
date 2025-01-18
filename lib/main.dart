import 'package:flutter/material.dart';
import 'package:testing_app/Screens/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePageScreen(),
      title: 'Testing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
