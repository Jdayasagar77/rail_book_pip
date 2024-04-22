import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rail_book_pip/models/shared_preferences.dart';

class EditUserDetailsPage extends StatefulWidget {
  @override
  _EditUserDetailsPageState createState() => _EditUserDetailsPageState();
}

class _EditUserDetailsPageState extends State<EditUserDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

onTapFunction({required BuildContext context}) async {
  DateTime? pickedDate = await showDatePicker(
    context: context,
    lastDate: DateTime.now(),
    firstDate: DateTime(2015),
    initialDate: DateTime.now(),
  );
  if (pickedDate == null) return;
  _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
}

  @override
  void initState() {
    super.initState();
    // Fetch user details from Firebase and pre-fill the fields

    SharedPref.getString("userUID").then((value) async {
      final docRef = FirebaseFirestore.instance.collection("Users").doc(value);
      docRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;

          setState(() {
            _nameController.text = data['name'];
            _dobController.text = data['dob'];
            _emailController.text = data['email'];
            _mobileController.text = data['mobile'];
            _addressController.text = data['address'];
          });
        },
        onError: (e) => print("Error getting document: $e"),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Name';
                    }
                    return null;
                  }),
                                const SizedBox(height: 20.0),

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
                          controller: _dobController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Date of Birth",
                              hintStyle: TextStyle(
                                  color: Color(0xFFb2b7bf), fontSize: 12.0)),
                        ),
                      ),

              TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Email';
                    }
                    return null;
                  }),
              TextFormField(
                  controller: _mobileController,
                  decoration: const InputDecoration(labelText: 'Mobile'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Mobile';
                    }
                    return null;
                  }),
              TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Address';
                    }
                    return null;
                  }),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (FirebaseAuth.instance.currentUser != null) {
                      print(FirebaseAuth.instance.currentUser?.uid);

                      FirebaseAuth.instance.currentUser
                          ?.verifyBeforeUpdateEmail(_emailController.text);

                      SharedPref.getString("userUID").then((value) {
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(value)
                            .update({
                          'name': _nameController.text,
                          'dob': _dobController.text,
                          'email': _emailController.text,
                          'mobile': _mobileController.text,
                          'address': _addressController.text,
                        }).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('User details updated successfully. Please ensure to verify before continuing ')),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to update user details')),
                          );
                        });
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to update user details')),
                      );
                    }

/*

 SharedPref.getString("userUID").then((value){
   FirebaseFirestore.instance.collection('Users').doc(value).update({
                      'name': _nameController.text,
                      'dob': _dobController.text,
                      'email': _emailController.text,
                      'mobile': _mobileController.text,
                      'address': _addressController.text,
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User details updated successfully')),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update user details')),
                      );
                    });
 });
 */
                    // Update user details in Firebase
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}