import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rail_book_pip/screens/bottom_bar_screen.dart';
import 'package:rail_book_pip/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('isLoggedIn') ?? false;
  await Firebase.initializeApp();
  runApp(status == true ? const Page1() : const Page2() );

// Ideal time to initialize
//await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
//...
}


