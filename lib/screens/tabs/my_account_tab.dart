import 'package:flutter/material.dart';

class MyAccountTab extends StatelessWidget {
  const MyAccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
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
               const SizedBox(
                  width: 100,
                  height: 20,
                  child: Text('Name'),
                  ),
              const SizedBox(
                height: 15.0,
              ),
               const SizedBox(
                  width: 100,
                  height: 20,
                  child: Text('Email ID'),
                  ),
              const SizedBox(
                height: 25.0,
              ),
              GestureDetector(
                        onTap: (){
                        
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
                              "My Profile",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w500),
                            ))),
                      ),
                        const SizedBox(
                height: 15.0,
              ),
              GestureDetector(
                        onTap: (){
                        
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
                              "Change Password",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                            ))),
                      ),
                        const SizedBox(
                height: 125.0,
              ),
              GestureDetector(
                        onTap: (){
                        
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width/2,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 0, 0),
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
        ]
      )
    );
  }
}
