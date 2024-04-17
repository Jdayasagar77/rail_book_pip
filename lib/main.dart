import 'package:flutter/material.dart';
import 'package:rail_book_pip/screens/bottom_bar_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    home: BottomTabBarScreen(),
    );
  }
}
