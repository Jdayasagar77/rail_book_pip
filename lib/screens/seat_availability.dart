import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rail_book_pip/models/seatavailable.dart';
import 'package:rail_book_pip/models/train_search.dart';
import 'package:rail_book_pip/screens/stripe_payment.dart';

import '../models/train_model.dart';

class SeatAvailabilityScreen extends StatefulWidget {
  final SeatAvailabilityParams seatAvailabilityParams;
  const SeatAvailabilityScreen(
      {Key? key, required this.seatAvailabilityParams})
      : super(key: key);
  @override
  _SeatAvailabilityScreenState createState() => _SeatAvailabilityScreenState(
      seatAvailabilityParams: this.seatAvailabilityParams);
}

class _SeatAvailabilityScreenState extends State<SeatAvailabilityScreen> {

  var _seats;

  SeatAvailabilityParams seatAvailabilityParams;
  _SeatAvailabilityScreenState(
      {required this.seatAvailabilityParams});

  
@override
void initState() {
  super.initState();
 // checkSeatAvailability();
}


  Future<void> checkSeatAvailability() async {
 debugPrint(seatAvailabilityParams.classType);
 debugPrint(seatAvailabilityParams.quota);
 debugPrint(seatAvailabilityParams.trainNo);


    final String apiUrl =
        'https://irctc1.p.rapidapi.com/api/v1/checkSeatAvailability';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': '5960234c6emsh2e935864ecc8378p110471jsn851268f65c1f',
      'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
    };

      final Map<String, String> queryParams = {
        'classType': seatAvailabilityParams.classType,
        'fromStationCode': seatAvailabilityParams.fromStationCode,
        'quota': seatAvailabilityParams.quota,
        'toStationCode': seatAvailabilityParams.toStationCode,
        'trainNo': seatAvailabilityParams.trainNo,
        'date': seatAvailabilityParams.date,
      };

      final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);

    //  final offlineResponse = await rootBundle.loadString('assets/json/seat_availability.json');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint('$responseData');

        if (responseData['status'] == true) {
          _seats = responseData['data']
              .map<SeatAvailability>(
                  (seatData) => SeatAvailability.fromJson(seatData))
              .toList();
        
        } else {
          // Handle error message from the API
          print('Error: ${responseData['message']}');
          setState(() {
          //  _isLoading = false;
          });
        }
      } else {
        // Handle HTTP error
        print('HTTP Error: ${response.statusCode}');
        // setState(() {
        // //  _isLoading = false;
        //   final responseData = jsonDecode(offlineResponse);
        //   List<SeatAvailability> seats = responseData['data']
        //       .map<SeatAvailability>(
        //           (seatData) => SeatAvailability.fromJson(seatData))
        //       .toList();
        //   _seats = seats;
        // });
      }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IRCTC Seat Availability'),
      ),
      body: 
      FutureBuilder(
  future: Future.delayed(const Duration(seconds: 1), () => 'Loaded'), // Assuming checkSeatAvailability returns Future<void>
  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
    checkSeatAvailability();
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else {
      return ListView.builder(
        itemCount: _seats.length,
       itemBuilder: (context, index) {
                SeatAvailability seat = _seats[index];
                return GestureDetector(
                  onTap: () {
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => const StripePaymentScreen()));
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
                            Text(
                               'Yo',
                           //   '${trainNameBro}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Yo',
                           //   'Train: ${trainNumber}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Date: ${seat.date}'),
                            Text('Fare: ${seat.totalFare}'),
                            Text('Current Status: ${seat.currentStatus}'),
                            Text(
                                'Confirm Probability: ${seat.confirmProbability} (${seat.confirmProbabilityPercent}%)'),
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
)
      /*
      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _seats.length,
              itemBuilder: (context, index) {
                SeatAvailability seat = _seats[index];
                final trainNumber = trains[index].trainNumber;
                final trainNameBro = trains[index].trainName;
                return GestureDetector(
                  onTap: () {
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => const StripePaymentScreen()));
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
                            Text(
                              '${trainNameBro}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Train: ${trainNumber}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Date: ${seat.date}'),
                            Text('Fare: ${seat.totalFare}'),
                            Text('Current Status: ${seat.currentStatus}'),
                            Text(
                                'Confirm Probability: ${seat.confirmProbability} (${seat.confirmProbabilityPercent}%)'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),


            */
    );
  }
}
