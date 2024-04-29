import 'package:flutter/material.dart';
import 'package:rail_book_pip/widgets/exception_handling.dart';
import 'package:rail_book_pip/models/seatavailable.dart';
import 'package:rail_book_pip/networkservices/seat_availability_service.dart';
import 'package:rail_book_pip/screens/payment_page.dart';
import '../models/train_model.dart';

class SeatAvailabilityScreen extends StatefulWidget {
  final SeatAvailabilityParams seatAvailabilityParams;
  final Train myTrain;
  const SeatAvailabilityScreen(
      {Key? key, required this.seatAvailabilityParams, required this.myTrain})
      : super(key: key);
  @override
  _SeatAvailabilityScreenState createState() => _SeatAvailabilityScreenState(
      seatAvailabilityParams: this.seatAvailabilityParams,
      myTrain: this.myTrain);
}

class _SeatAvailabilityScreenState extends State<SeatAvailabilityScreen> {
  Train myTrain;
  SeatAvailabilityParams seatAvailabilityParams;

  _SeatAvailabilityScreenState(
      {required this.seatAvailabilityParams, required this.myTrain});

  SeatAvailabilityService _seatAvailabilityService = SeatAvailabilityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IRCTC Seat Availability'),
      ),
      body: FutureBuilder(
        future: _seatAvailabilityService.checkSeatAvailability(
            seatAvailabilityParams), // Assuming checkSeatAvailability returns Future<void>
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return CustomErrorWidget(errorMessage: snapshot.error.toString());
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                SeatAvailability seat = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentPageStripe(
                                  myTrain: myTrain,
                                  mySeat: seat,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text('Date: ${seat.date}'),
                            Text('Fare: ${seat.totalFare}'),
                            Text('Current Status: ${seat.currentStatus}'),
                            Text(
                                'Confirm Probability: ${seat.confirmProbability}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
