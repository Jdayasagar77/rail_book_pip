import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:rail_book_pip/models/payment_stripe.dart';
import 'package:rail_book_pip/models/seatavailable.dart';
import 'package:rail_book_pip/reusable_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/train_model.dart';

class PaymentPageStripe extends StatefulWidget {
   
    final Train myTrain;
    final SeatAvailability mySeat;
   PaymentPageStripe({super.key, required this.myTrain, required this.mySeat});

  @override
  State<PaymentPageStripe> createState() => _PaymentPageStripeState(myTrain : this.myTrain, mySeat : this.mySeat);
}

class _PaymentPageStripeState extends State<PaymentPageStripe> {
  final db = FirebaseFirestore.instance;
  Train myTrain;
SeatAvailability mySeat;
_PaymentPageStripeState({required this.myTrain, required  this.mySeat});

  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();


  final formkey = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  final formkey3 = GlobalKey<FormState>();
  final formkey4 = GlobalKey<FormState>();
  final formkey5 = GlobalKey<FormState>();
  final formkey6 = GlobalKey<FormState>();
  final formkey7 = GlobalKey<FormState>();
  final formkey8 = GlobalKey<FormState>();

  List<String> currencyList = <String>[
    'USD',
    'INR',
    'EUR',
    'JPY',
    'GBP',
    'AED'
  ];
  String selectedCurrency = 'USD';

  bool hasDonated = false;

  bool paymentCompleted = false;
  Duration paymentTimeoutDuration = Duration(minutes: 7);
  
static String generateTransactionId() {
  // Use a StringBuffer for efficient string building
  final buffer = StringBuffer();
  const length = 16;
  const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  for (int i = 0; i < length; i++) {
    buffer.write(characters[random.nextInt(characters.length)]);
  }
  return buffer.toString();
}


  transactionRegistration() async {
      final SharedPreferences prefs  = await SharedPreferences.getInstance();

    debugPrint('${prefs.getString('userUID')}');
debugPrint(myTrain.trainName);
debugPrint(myTrain.trainNumber);
debugPrint(mySeat.currentStatus);
debugPrint(mySeat.date);

    
      

        final transaction = <String, String> {
          "name": nameController.text,
          "transactionID": generateTransactionId(),
          "amount": amountController.text,
          
          "currentStatus": mySeat.currentStatus,
           "trainName": myTrain.trainName,
          "trainNo": myTrain.trainNumber,
          "date": mySeat.date,
        };

// Add a new document with a generated ID
      debugPrint(myTrain.trainName);
debugPrint(myTrain.trainNumber);
debugPrint(mySeat.currentStatus);
debugPrint(mySeat.date);

            final userDocRef = db.collection("Users").doc(prefs.getString('userUID'));

// Create a reference to the subcollection within the user document
final transactionCollectionRef = userDocRef.collection("transaction");

// Generate a unique document ID (optional, but recommended)
final String transactionId =  DateFormat('yyyy-MM-dd').format(DateTime.now());
// Create a new document within the subcollection
transactionCollectionRef.doc(transactionId).set(transaction);
            
debugPrint('${prefs.getString('userUID')}');

        // ignore: use_build_context_synchronously
       
}
  






void startPaymentTimeout(context) {

  int remainingSeconds = paymentTimeoutDuration.inSeconds;

  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
    remainingSeconds--;
    if (remainingSeconds <= 0) {
      timer.cancel();
      handlePaymentTimeout();
    } else {
      SnackBar snackBar = SnackBar(
      content: Text("Time remaining: ${remainingSeconds ~/ 60}:${remainingSeconds % 60}",
          style: TextStyle(fontSize: 20)),
      backgroundColor: Colors.indigo,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
   //   debugPrint("Time remaining: ${remainingSeconds ~/ 60}:${remainingSeconds % 60}");
    }
  });
}

void handlePaymentTimeout() {
  print("Payment timeout: Payment process failed");
  // Handle the payment timeout, for example, show a message to the user
}

    

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
          // convert string to double
          amount: (int.parse(amountController.text) * 100).toString(),
          currency: selectedCurrency,
          name: nameController.text,
          address: addressController.text,
          pin: pincodeController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text);

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],

          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Image(
              image: AssetImage("assets/images/train1.png"),
              height: 100,
              fit: BoxFit.cover,
            ),
            hasDonated
                ? Padding(
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
                          "Thanks for Booking Train Tickets on Rail PiP with Amount $selectedCurrency${amountController.text}",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Fill Details for Payment",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: ReusableTextField(
                                    formkey: formkey,
                                    controller: amountController,
                                    isNumber: true,
                                    title: "Payment Amount",
                                    hint: ""),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              DropdownMenu<String>(
                                inputDecorationTheme: InputDecorationTheme(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 0),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                initialSelection: currencyList.first,
                                onSelected: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    selectedCurrency = value!;
                                  });
                                },
                                dropdownMenuEntries: currencyList
                                    .map<DropdownMenuEntry<String>>(
                                        (String value) {
                                  return DropdownMenuEntry<String>(
                                      value: value, label: value);
                                }).toList(),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ReusableTextField(
                            formkey: formkey1,
                            title: "Name",
                            hint: "Ex. John Doe",
                            controller: nameController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: ReusableTextField(
                                  formkey: formkey7,
                                  title: "Age",
                                  hint: "Ex. 23",
                                  controller: ageController,
                                ),
                              ),
                              const Expanded(
                                flex: 5,
                                child: Text(
                                  'Class : SL',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ReusableTextField(
                            formkey: formkey2,
                            title: "Address Line",
                            hint: "Ex. 123 Main St",
                            controller: addressController,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: ReusableTextField(
                                    formkey: formkey3,
                                    title: "City",
                                    hint: "Ex. New Delhi",
                                    controller: cityController,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 5,
                                  child: ReusableTextField(
                                    formkey: formkey4,
                                    title: "State (Short code)",
                                    hint: "Ex. DL for Delhi",
                                    controller: stateController,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 5,
                                  child: ReusableTextField(
                                    formkey: formkey5,
                                    title: "Country (Short Code)",
                                    hint: "Ex. IN for India",
                                    controller: countryController,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 5,
                                child: ReusableTextField(
                                  formkey: formkey6,
                                  title: "Pincode",
                                  hint: "Ex. 123456",
                                  controller: pincodeController,
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent.shade400),
                              child: const Text(
                                "Proceed to Pay",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              onPressed: () async {

                                if (formkey.currentState!.validate() &&
                                    formkey1.currentState!.validate() &&
                                    formkey2.currentState!.validate() &&
                                    formkey3.currentState!.validate() &&
                                    formkey4.currentState!.validate() &&
                                    formkey5.currentState!.validate() &&
                                    formkey6.currentState!.validate()) {

                                  await initPaymentSheet();

                                  try {

                                   // startPaymentTimeout(context);
                                    await Stripe.instance.presentPaymentSheet();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Payment Done",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ));
transactionRegistration();

                                    setState(() {

                                      hasDonated = true;
                                      paymentCompleted = true;



                                    });

                                    addressController.clear();
                                    cityController.clear();
                                    stateController.clear();
                                    countryController.clear();
                                    pincodeController.clear();

                                  } catch (e) {
                                    print("Payment Sheet failed");
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Payment Failed",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ));
                                  }
                                }
                              },
                            ),
                          )
                        ])),
          ],
        ),
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('nameController', nameController));
  }
}
