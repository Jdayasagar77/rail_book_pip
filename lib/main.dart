import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rail_book_pip/screens/bottom_bar_screen.dart';
import 'package:rail_book_pip/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('isLoggedIn') ?? false;
   Stripe.publishableKey="pk_test_51P8rqhSB16OkGfJwG4rXkxTgHYgvnVhc9QIqRDPSotqbP92Gjof2ibZKTsYknlGIMnp9WUILNTbWjww1TiVNTVQT00KEyPskUy";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  runApp(status == true ? const Page2() : const Page1() );

// Ideal time to initialize
//await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
//...

}