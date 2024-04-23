import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rail_book_pip/models/seatavailable.dart';


class SeatAvailabilityScreen extends StatefulWidget {
  @override
  _SeatAvailabilityScreenState createState() => _SeatAvailabilityScreenState();
}

class _SeatAvailabilityScreenState extends State<SeatAvailabilityScreen> {
  List<SeatAvailability> _seats = [];
  bool _isLoading = false;

  Future<void> checkSeatAvailability() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = 'https://irctc1.p.rapidapi.com/api/v1/checkSeatAvailability';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': '1de23605f5msh6e24f587c98de99p1692ccjsnec101976d820',
      'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
    };
    final Map<String, String> queryParams = {
      'classType': '2A',
      'fromStationCode': 'ST',
      'quota': 'GN',
      'toStationCode': 'BVI',
      'trainNo': '19038',
      'date': '2024-04-24',
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: headers);

debugPrint('$response');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == true) {
var myData = [
    {
      "ticket_fare": 710,
      "catering_charge": 0,
      "alt_cnf_seat": null,
      "total_fare": 710,
      "date": "24-4-2024",
      "confirm_probability_percent": "93",
      "confirm_probability": "High",
      "current_status": "RLWL4/WL4."
    },
    {
      "ticket_fare": 710,
      "catering_charge": 0,
      "alt_cnf_seat": null,
      "total_fare": 710,
      "date": "25-4-2024",
      "confirm_probability_percent": "93",
      "confirm_probability": "High",
      "current_status": "RLWL3/WL3."
    },
    {
      "ticket_fare": 710,
      "catering_charge": 0,
      "alt_cnf_seat": null,
      "total_fare": 710,
      "date": "26-4-2024",
      "confirm_probability_percent": "86",
      "confirm_probability": "High",
      "current_status": "RLWL15/WL9."
    },
    {
      "ticket_fare": 710,
      "catering_charge": 0,
      "alt_cnf_seat": null,
      "total_fare": 710,
      "date": "27-4-2024",
      "confirm_probability_percent": "94",
      "confirm_probability": "High",
      "current_status": "RLWL1/WL1."
    },
    {
      "ticket_fare": 710,
      "catering_charge": 0,
      "alt_cnf_seat": null,
      "total_fare": 710,
      "date": "28-4-2024",
      "confirm_probability_percent": "86",
      "confirm_probability": "High",
      "current_status": "RLWL14/WL13."
    },
    {
      "ticket_fare": 710,
      "catering_charge": 0,
      "alt_cnf_seat": null,
      "total_fare": 710,
      "date": "29-4-2024",
      "confirm_probability_percent": "94",
      "confirm_probability": "High",
      "current_status": "RLWL2/WL1."
    }
  ];


        List<SeatAvailability> seats = myData.map<SeatAvailability>((seatData) => SeatAvailability.fromJson(seatData)).toList();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IRCTC Seat Availability'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _seats.isEmpty
              ? Center(child: Text('No data available'))
              : ListView.builder(
                  itemCount: _seats.length,
                  itemBuilder: (context, index) {
                    final seat = _seats[index];
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
                                "Jack",
                             //   'Train: ${seat.trainNumber} - ${seat.trainName}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text('Date: ${seat.date}'),
                              Text('Fare: ${seat.totalFare}'),
                              Text('Current Status: ${seat.currentStatus}'),
                              Text('Confirm Probability: ${seat.confirmProbability} (${seat.confirmProbabilityPercent}%)'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: checkSeatAvailability,
        tooltip: 'Check Seat Availability',
        child: Icon(Icons.search),
    )
    );
  }
}
