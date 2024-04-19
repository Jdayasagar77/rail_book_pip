import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Initial Selected Value 
  String dropdownvalue = 'Item 1';    
  
  // List of items in our dropdown menu 
  var items = [     
    'Item 1', 
    'Item 2', 
    'Item 3', 
    'Item 4', 
    'Item 5', 
  ]; 
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
child: Center(
  child: Column(
    children: [
        DropdownButton( 
                  
                // Initial Value 
                value: dropdownvalue, 
                  
                // Down Arrow Icon 
                icon: const Icon(Icons.keyboard_arrow_down),     
                  
                // Array list of items 
                items: items.map((String items) { 
                  return DropdownMenuItem( 
                    value: items, 
                    child: Text(items), 
                  ); 
                }).toList(), 
                // After selecting the desired option,it will 
                // change button value to selected value 
                onChanged: (String? newValue) {  
                  setState(() { 
                    dropdownvalue = newValue!; 
                  }); 
                }, 
              ), 
    ],
  ),
),
    );
  }
}