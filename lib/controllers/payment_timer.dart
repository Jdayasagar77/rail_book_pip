import 'dart:async';

import 'package:flutter/material.dart';

class PaymentTimeoutNotifier extends ChangeNotifier {
  bool _isPaymentSuccessful = false;

  int _remainingSeconds = Duration(minutes: 7).inSeconds;

  bool get isPaymentSuccessful => _isPaymentSuccessful;
  int get remainingSeconds => _remainingSeconds;

  void startPaymentTimeout(BuildContext context) {
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;

      if (_remainingSeconds <= 0) {
        timer.cancel();
        handlePaymentTimeout();
      } else {
        SnackBar snackBar = SnackBar(
          content: SizedBox(
            height: 30, // Adjust the height as needed
            width: 100,
            child: Center(
              child: Text(
                "Time remaining: ${_remainingSeconds ~/ 60}:${_remainingSeconds % 60}",
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          backgroundColor: Colors.indigo,
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 80),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

  }


  void handlePaymentTimeout() {
    print("Payment timeout: Payment process failed");
    // Handle the payment timeout, for example, show a message to the user

  }
}


/*
           

                                    timer = Timer.periodic(
                                        const Duration(seconds: 1), (timer) {
                                      _remainingSeconds--;

                                      if (_remainingSeconds <= 0) {
                                        timer.cancel();
                                        print("Payment Sheet timed out");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                            "Payment Timed Out",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.redAccent,
                                        ));
                                        Navigator.pop(context);
                                      }
                                      
                                      else {
                                        SnackBar snackBar = SnackBar(
                                          content: SizedBox(
                                          
                                            child: Center(
                                              child: Text(
                                                "Time remaining: ${_remainingSeconds ~/ 60}:${_remainingSeconds % 60}",
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                          backgroundColor: Colors.indigo,
                                          dismissDirection: DismissDirection.up,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  150,
                                              left: 50,
                                              right: 50),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    });

*/


/*

   const SizedBox(
              height: 10,
            ),
            const Image(
              image: AssetImage("assets/images/train1.png"),
              height: 100,
              fit: BoxFit.cover,
            ),
            Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          "Order Successfull",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Thanks for Booking Train Tickets on Rail PiP with Amount $selectedCurrency ${amountController.text}",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )

*/