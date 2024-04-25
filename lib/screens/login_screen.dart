// ignore_for_file: use_build_context_synchronously


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rail_book_pip/screens/bottom_bar_screen.dart';
import 'package:rail_book_pip/screens/payment_page.dart';
import 'package:rail_book_pip/screens/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogIn(),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "";
late SharedPreferences prefs;

// Initialize shared preferences
  TextEditingController mailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

 String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    // Define your password validation criteria here
    // Example criteria: minimum length of 8 characters, at least one uppercase letter, one lowercase letter, one number, and one special character
    final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
       ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'Password must be at least 8 characters long and include uppercase, lowercase, number, and special characters',
              style: TextStyle(fontSize: 18.0),
            )));
     return 'Password must be at least 8 unique characters ';
    }
    return null;
  }

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
                            prefs = await SharedPreferences.getInstance();
                           prefs.setBool("isLoggedIn", true);
                           prefs.setString('userEmail', email);
                           prefs.setString('userPassword', password);
if (FirebaseAuth.instance.currentUser != null) {
  prefs.setString('userUID', FirebaseAuth.instance.currentUser!.uid);
  

  debugPrint(FirebaseAuth.instance.currentUser?.uid);
}  

      Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomTabBarScreen()));
    } on FirebaseAuthException catch (e) {
        debugPrint('${e.message}');

      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              '${e.message}',
              style: const TextStyle(fontSize: 18.0),
            )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
                const SizedBox(
                height: 100.0,
              ),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    "assets/images/train1.png",
                    fit: BoxFit.fitWidth,
                  )),
              const SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          validator: (value) {
                                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            } else  if (!emailRegex.hasMatch(value)) {
                                      return 'Please Enter a Valid Email address';

      } 

                            return null;
                          },
                          controller: mailcontroller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  color: Color(0xFFb2b7bf), fontSize: 18.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          controller: passwordcontroller,
                          validator: _validatePassword,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Color(0xFFb2b7bf), fontSize: 18.0)),
                     obscureText: true,   ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          if(_formkey.currentState!.validate()){
                            setState(() {
                              email= mailcontroller.text;
                              password=passwordcontroller.text;
                            });
                          }
                          userLogin();

                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 30.0),
                            decoration: BoxDecoration(
                                color: const Color(0xFF273671),
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                                child: Text(
                              "Sign In",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w500),
                            ))),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
             
              const SizedBox(
                height: 40.0,
              ),
              const Text(
                "or LogIn with",
                style: TextStyle(
                    color: Color(0xFF273671),
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                    //  AuthMethods().signInWithGoogle(context);

                    },
                    child: Image.asset(
                      "assets/images/google.png",
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  GestureDetector(
                    onTap: (){
                    //  AuthMethods().signInWithApple();

      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPageStripe()));


                    },
                    child: Image.asset(
                      "assets/images/apple.png",
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?",
                      style: TextStyle(
                          color: Color(0xFF8c8e98),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const SignUp()));
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(
                          color: Color(0xFF273671),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}