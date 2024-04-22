
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rail_book_pip/screens/bottom_bar_screen.dart';
import 'package:rail_book_pip/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

final ImagePicker _picker = ImagePicker();
      XFile? _image;
      // Read bytes from the file object
 
// base64 encode the bytes
String? _base64String;
late SharedPreferences prefs;
final db = FirebaseFirestore.instance;

 DateTime? _date;

  String display() {
    if (_date == null) {
      return 'NONE';
    } else {
      return 'year:${_date!.year}\nmonth:${_date!.month}\nday:${_date!.day}';
    }
  }


  String email = "", password = "", firstname = "", lastname = "", mobile = "", dob = "";
  TextEditingController firstnamecontroller = new TextEditingController();
    TextEditingController lastnamecontroller = new TextEditingController();
        TextEditingController dobcontroller = new TextEditingController();
      TextEditingController mobilecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController mailcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

onTapFunction({required BuildContext context}) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    lastDate: DateTime.now(),
    firstDate: DateTime(2015),
    initialDate: DateTime.now(),
  );
  if (pickedDate == null) return;
  dobcontroller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
}



 registration() async {
    if (firstnamecontroller.text!= "" && mailcontroller.text!=""&& mobilecontroller.text!=""&& lastnamecontroller.text!="" && passwordcontroller.text!="" && dobcontroller.text!= "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Registered Successfully",
          style: TextStyle(fontSize: 20.0),
        ),
        ),
        );

        final user = <String, String>{
  "firstname": firstnamecontroller.text,
  "lastname": lastnamecontroller.text,
  "dob": dobcontroller.text,
   "email": mailcontroller.text,
  "mobile": mobilecontroller.text,
  "password": passwordcontroller.text,
  "image":_base64String ?? "",
};

// Add a new document with a generated ID
db.collection("Users").doc(userCredential.user?.uid).set(user, SetOptions(merge: true)); 
                      prefs = await SharedPreferences.getInstance();
                    
                           prefs.setBool("isLoggedIn", true);     
                             prefs.setString('userUID', userCredential.user!.uid);
   // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const BottomTabBarScreen()));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "${e.message}",
              style: const TextStyle(fontSize: 18.0),
            )));
      }
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
                  width: MediaQuery.of(context).size.width,
                                  height: 100,
          
                  child: _image == null
                ? const Text(
                  'No image selected.',
                  textAlign: TextAlign.center,
                )
                : Image.file(File(_image!.path)),
                ),
              const SizedBox(
                height: 10.0,
              ),
 FloatingActionButton(
            onPressed: getImage,
            tooltip: 'Pick Image',
            child: const Icon(Icons.add_a_photo),
          ),
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
                            const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter First Name';
                            }
                            return null;
                          },
                          controller: firstnamecontroller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "First Name",
                              hintStyle: TextStyle(
                                  color: Color(0xFFb2b7bf), fontSize: 12.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                       Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Last Name';
                            }
                            return null;
                          },
                          controller: lastnamecontroller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Last Name",
                              hintStyle: TextStyle(
                                  color: Color(0xFFb2b7bf), fontSize: 12.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                   
                       Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                                  readOnly: true,
onTap: () {
  onTapFunction(context: context);
},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Date of Birth';
                            }
                            return null;
                          },
                          controller: dobcontroller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Date of Birth",
                              hintStyle: TextStyle(
                                  color: Color(0xFFb2b7bf), fontSize: 12.0)),
                        ),
                      ),

                      
                       const SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                          controller: mailcontroller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  color: Color(0xFFb2b7bf), fontSize: 12.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                       Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Mobile Number';
                            }
                            return null;
                          },
                          controller: mobilecontroller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Mobile",
                              hintStyle: TextStyle(
                                  color: Color(0xFFb2b7bf), fontSize: 12.0)),
                        ),
                      ),
                       const SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          controller: passwordcontroller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Color(0xFFb2b7bf), fontSize: 12.0)),
               obscureText: true,  ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          if(_formkey.currentState!.validate()){
                           
                            setState(() {
                              debugPrint('Sign Up');
                              email = mailcontroller.text;
                              firstname = firstnamecontroller.text;
                              lastname = lastnamecontroller.text;
                              dob = dobcontroller.text;
                              mobile = mobilecontroller.text;
                              password = passwordcontroller.text;
                            });
                          }
                          registration();
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width/2,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: const Color(0xFF273671),
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                                child: Text(
                              "Sign Up",
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
                height: 15.0,
              ),
              const Text(
                "or LogIn with",
                style: TextStyle(
                    color: Color(0xFF273671),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/google.png",
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 30.0,
                  ),
                  Image.asset(
                    "assets/images/apple.png",
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?",
                      style: TextStyle(
                          color: Color(0xFF8c8e98),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LogIn()));
                    },
                    child: const Text(
                      "LogIn",
                      style: TextStyle(
                          color: Color(0xFF273671),
                          fontSize: 12.0,
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

   Future getImage() async {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    Uint8List _bytes = await image!.readAsBytes();

        setState(() {
          _image = image;
          _base64String = base64.encode(_bytes);
        });
      }
}

