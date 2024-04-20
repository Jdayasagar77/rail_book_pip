import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    // Fetch user details from Firebase and pre-fill the fields
    FirebaseFirestore.instance.collection('Users').doc('user_id').get().then((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        _nameController.text = data?['name'];
        _dobController.text = data?['dob'];
        _emailController.text = data?['email'];
        _mobileController.text = data?['mobile'];
        _addressController.text = data?['address'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Name';
                            }
                            return null;
                          }
              ),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'DoB is required';
                            }
                            return null;
                          }
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          }
              ),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile'),
                validator:(value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Mobile';
                            }
                            return null;
                          }
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Address';
                            }
                            return null;
                          }
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Update user details in Firebase
                    FirebaseFirestore.instance.collection('Users').doc('user_id').update({
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
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}