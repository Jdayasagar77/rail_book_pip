import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rail_book_pip/models/seatavailable.dart';

class SeatAvailabilityScreen extends StatefulWidget {
  final SeatAvailabilityParams seatAvailabilityParams;
  final List<String> trainName;
  const SeatAvailabilityScreen({Key? key, required this.seatAvailabilityParams, required this.trainName})
      : super(key: key);
  @override
  _SeatAvailabilityScreenState createState() => _SeatAvailabilityScreenState(
      seatAvailabilityParams: this.seatAvailabilityParams, trainName: this.trainName);
}

class _SeatAvailabilityScreenState extends State<SeatAvailabilityScreen> {
  List<SeatAvailability> _seats = [];
  bool _isLoading = false;
  SeatAvailabilityParams seatAvailabilityParams;
  List<String> trainName;
  _SeatAvailabilityScreenState({required this.seatAvailabilityParams, required this.trainName});

  @override
  void initState() {
    super.initState();
    checkSeatAvailability();
  }

  Future<void> checkSeatAvailability() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl =
        'https://irctc1.p.rapidapi.com/api/v1/checkSeatAvailability';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': '5960234c6emsh2e935864ecc8378p110471jsn851268f65c1f',
      'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
    };
    String fromStationCode = seatAvailabilityParams.fromStationCode;
    String toStationCode = seatAvailabilityParams.toStationCode;
    String dateOfJourney = seatAvailabilityParams.date;

for (var element in seatAvailabilityParams.trainNo) {
  
 final Map<String, String> queryParams = {
      'classType': seatAvailabilityParams.classType,
      'fromStationCode': seatAvailabilityParams.fromStationCode,
      'quota': seatAvailabilityParams.quota,
      'toStationCode': seatAvailabilityParams.toStationCode,
      'trainNo': element,
      'date': seatAvailabilityParams.date,
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: headers);

    final offlineResponse = await rootBundle.loadString('assets/json/seat_availability.json');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
                        debugPrint('$responseData');

      if (responseData['status'] == true) {
        List<SeatAvailability> seats = responseData['data']
            .map<SeatAvailability>(
                (seatData) => SeatAvailability.fromJson(seatData))
            .toList();
        setState(() {
          _seats = seats;
          _isLoading = false;
          debugPrint('$seats');
        });
      } else {
        // Handle error message from the API
        print('Error: ${responseData['message']}');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Handle HTTP error
      print('HTTP Error: ${response.statusCode}');
      setState(() {
          _isLoading = false;
        final responseData = jsonDecode(offlineResponse);
        List<SeatAvailability> seats = responseData['data']
            .map<SeatAvailability>(
                (seatData) => SeatAvailability.fromJson(seatData))
            .toList();
            _seats = seats;
        });
    }
}


   



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IRCTC Seat Availability'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _seats.isEmpty
              ? const Center(child: Text('No data available'))
              : ListView.builder(
                  itemCount: _seats.length,
                  itemBuilder: (context, index) {
                    final seat = _seats[index];
                    final trainNumber = seatAvailabilityParams.trainNo[index];
                    final trainNameBro = trainName[index];
                    return Padding(
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
                    );
                  },
                ),
    );
  }
}
