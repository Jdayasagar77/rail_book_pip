import 'package:flutter/material.dart';

class OrderSuccessfulPage extends StatelessWidget {
  final String selectedCurrency;
  final String amount;

  const OrderSuccessfulPage({Key? key, required this.selectedCurrency, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              children: [
                const SizedBox(height: 10),
                const Image(
                  image: AssetImage("assets/images/train1.png"),
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 30), // Increased spacing for better balance
                const Text(
                  "Order Successful",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    
                    "Thanks for Booking Train Tickets on Rail PiP with Amount $selectedCurrency $amount",
                    style: const TextStyle(fontSize: 18),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 20), // Added spacing for readability
                ElevatedButton(
                  onPressed: () {
                    // Handle button press action (e.g., navigate to home)
                    Navigator.pop(context); // Assuming you want to go back
                  },
                  child: const Text('Go Back'),
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
