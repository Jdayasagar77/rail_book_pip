import 'package:flutter/material.dart';

class OrderSuccessfulPage extends StatelessWidget {
  final String selectedCurrency;
  final String amount;

  const OrderSuccessfulPage({Key? key, required this.selectedCurrency, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Successful'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
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
            Text(
              "Thanks for Booking Train Tickets on Rail PiP with Amount $selectedCurrency $amount",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20), // Added spacing for readability
            ElevatedButton(
              onPressed: () {
                // Handle button press action (e.g., navigate to home)
                Navigator.pop(context); // Assuming you want to go back
              },
              child: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
    
                minimumSize: const Size(150, 50), // Set appropriate button size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
