import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rail_book_pip/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    home: LogIn(),
    );
  }
}
