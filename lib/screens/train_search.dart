import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rail_book_pip/models/seatavailable.dart';
import 'package:rail_book_pip/models/train_model.dart';
import 'package:rail_book_pip/models/train_searchrequest.dart';
import 'package:rail_book_pip/screens/seat_availability.dart';

class TrainSearchScreen extends StatefulWidget {
  final TrainSearchRequest trainAvailabilityParams;
  TrainSearchScreen({Key? key, required this.trainAvailabilityParams})
      : super(key: key);
  @override
  _TrainSearchScreenState createState() => _TrainSearchScreenState(
      trainAvailabilityParams: this.trainAvailabilityParams);
}

class _TrainSearchScreenState extends State<TrainSearchScreen> {
  _TrainSearchScreenState({required this.trainAvailabilityParams});

  List<Train> _trains = [];
  TrainSearchRequest trainAvailabilityParams;

  @override
  void initState() {
    super.initState();
    searchTrains(
      trainAvailabilityParams.fromStationCode,
      trainAvailabilityParams.toStationCode,
      trainAvailabilityParams.date,
      trainAvailabilityParams.classType,
    );
  }

  Future<void> searchTrains(String fromStationCode, String toStationCode,
      String dateOfJourney, String myClassType) async {

    debugPrint(fromStationCode);
    debugPrint(toStationCode);
    debugPrint(dateOfJourney);

    const baseUrl = 'https://irctc1.p.rapidapi.com/api/v3/trainBetweenStations';

    final url = Uri.parse('$baseUrl?fromStationCode=$fromStationCode&toStationCode=$toStationCode&dateOfJourney=$dateOfJourney');

    final Map<String, String> headers = {
      'X-RapidAPI-Key': '5960234c6emsh2e935864ecc8378p110471jsn851268f65c1f',
      'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
    };

    final response = await http.get(url, headers: headers);
    debugPrint(response.body);

    try {
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        //Handle the response data as needed
        _trains = List<Train>.from(
            responseData['data'].map((trainData) => Train.fromJson(trainData)));

        debugPrint('${responseData}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      if (_trains.isEmpty) {
        print('Request failed with status: ${response.statusCode}');
        debugPrint('${response}');

        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: Text('Network Error: $error'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('IRCTC Train Search'),
        ),
        body: Center(
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: _trains.length,
                  itemBuilder: (context, index) {
                    final train = _trains[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeatAvailabilityScreen(
                                    seatAvailabilityParams:
                                        SeatAvailabilityParams(
                                            trainNo: train.trainNumber,
                                            fromStationCode: train.from,
                                            toStationCode: train.to,
                                            date: train.trainDate,
                                            classType: trainAvailabilityParams.classType,
                                            quota: trainAvailabilityParams.quota), myTrain: train,

                                                ),
                                                ),
                                                );
                      },
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${train.trainNumber} - ${train.trainName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Run Days: ${train.runDays.join(", ")}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Text(
                                'Source: ${train.fromStationName} (${train.from})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Departure: ${train.fromStd}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Destination: ${train.toStationName} (${train.to})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Arrival: ${train.toStd}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Text(
                                'Duration: ${train.duration}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Train Type: ${train.trainType}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Train Date: ${train.trainDate}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Text(
                                'Classes Available: ${train.classType.join(", ")}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
            future: Future.delayed(const Duration(seconds: 1), () => 'Loaded'),
          ),
        ));
  }
}
