import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    // Define your password validation criteria here
    // Example criteria: minimum length of 8 characters, at least one uppercase letter, one lowercase letter, one number, and one special character
    final passwordRegex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    if (!passwordRegex.hasMatch(value)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Password must be at least 8 characters long and include uppercase, lowercase, number, and special characters',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
      return 'Password must be at least 8 unique characters ';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Current Password'),
                  validator: _validatePassword),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
                validator: _validatePassword,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                validator: _validatePassword,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser != null) {
                    final docRef = FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser?.uid);
                    docRef.get().then(
                      (DocumentSnapshot doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        if (_formKey.currentState!.validate()) {
                          // Change password logic goes here
                          if (_currentPasswordController.text ==
                                  data['password'] &&
                              _newPasswordController.text ==
                                  _confirmPasswordController.text) {
                            debugPrint('Password Correct');

                            FirebaseAuth.instance.currentUser?.updatePassword(
                                _confirmPasswordController.text);

                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .update({
                              'password': _confirmPasswordController.text,
                            }).then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Password updated successfully'),
                                ),
                              );
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Failed to update user details')),
                              );
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Check Your Credentials Properly')),
                            );
                          }
                        }
                      },
                      onError: (e) => print("Error getting document: $e"),
                    );
                  }
                },
                child: const Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
