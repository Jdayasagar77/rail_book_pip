import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
   Razorpay? _razorpay;

  TextEditingController paycontroller = TextEditingController();

  void openCheckOut(amount) async {
    var options = {
      'key': 'aI1H47dJSdF1QsBfxeulMDCj',
      'amount': amount,
      'name': 'Jakate Daya Sagar',
      'description': 'Fine T-Shirt',
      'prefill': {
        'contact': '8888888888',
    'email': 'test@razorpay.com'
  },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay?.open(options);
      
    } catch (e) {
      debugPrint('Error : ${e.toString()}');
    }

    void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
      Fluttertoast.showToast(
          msg: 'Payment Successful${response.paymentId}',
          toastLength: Toast.LENGTH_SHORT);
    }

    void handlePaymentErrorResponse(PaymentFailureResponse response) {
      Fluttertoast.showToast(
          msg: 'Payment Fail${response.message}',
          toastLength: Toast.LENGTH_SHORT);
    }

    void handleExternalWalletSelected(ExternalWalletResponse response) {
      Fluttertoast.showToast(
          msg: 'External Wallet ${response.walletName}',
          toastLength: Toast.LENGTH_SHORT);
    }

    @override
    void dispose() {
      super.dispose();
      _razorpay?.clear();
    }

    @override
    void initState() {
      super.initState();
      _razorpay = Razorpay();
      _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      _razorpay?.on(
          Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
      _razorpay?.on(
          Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
      _razorpay?.open(options);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset(
              'assets/images/train1.png',
              width: 300,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Welcome to RazorPay Gateway Integration',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                cursorColor: Colors.white,
                autofocus: false,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Enter Amount to be Paid',
                  labelStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white10, width: 1.0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  )
                ),
                controller: paycontroller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Amount to be Paid';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
  debugPrint('Clicked');
if (paycontroller.text.toString().isNotEmpty) {
  debugPrint('Clicked');
  setState(() {
    int amount = int.parse(paycontroller.text.toString());
    openCheckOut(amount);
  });
}
            },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green
              ), child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Make Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
