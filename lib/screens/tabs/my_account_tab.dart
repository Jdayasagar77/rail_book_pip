import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rail_book_pip/models/shared_pref.dart';
import 'package:rail_book_pip/screens/change_password.dart';
import 'package:rail_book_pip/screens/edit_user.dart';
import 'package:rail_book_pip/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountTab extends StatefulWidget {
  const MyAccountTab({super.key});

  @override
  State<MyAccountTab> createState() => _MyAccountTabState();
}

class _MyAccountTabState extends State<MyAccountTab> {
// Initialize shared preferences

  bool _isLoading = false; //bool variable created
  var _data;

  void logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LogIn()));
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    SharedPref.getString("userUID").then((value) {
      debugPrint(value);
      final docRef = FirebaseFirestore.instance.collection("Users").doc(value);
      docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            _data = data;
            _isLoading = true;
          });
            
        },
        onError: (e) => print("Error getting document: $e"),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      const SizedBox(
        height: 100.0,
      ),
      Container(
        width: 350,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 2, 2, 2), // Change the background color as needed
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 120,
                height: 120,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: _isLoading
                    ? Image.memory(
                        base64Decode(_data['image']),
                        fit: BoxFit.cover,
                      )
                    : const CircularProgressIndicator()
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _isLoading ? Text(
                      "${_data['firstname']}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ) : const Text(
                      "Loading...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ) ,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _isLoading ? Text(
                      "${_data['email']}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 205, 255, 148),
                      ),
                    ) : const Text(
                      "Loading...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ) ,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 25.0,
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditUserDetailsPage()));
        },
        child: Container(
            width: MediaQuery.of(context).size.width / 2,
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(30)),
            child: const Center(
                child: Text(
              "My Profile",
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500),
            ))),
      ),
      const SizedBox(
        height: 15.0,
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChangePasswordPage()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.circular(30)),
          child: const Center(
            child: Text(
              "Change Password",
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 125.0,
      ),
      GestureDetector(
        onTap: () {
          logoutUser();
        },
        child: Container(
            width: MediaQuery.of(context).size.width / 2,
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(30)),
            child: const Center(
                child: Text(
              "Logout",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500),
            ))),
      ),
    ]));
  }
}
