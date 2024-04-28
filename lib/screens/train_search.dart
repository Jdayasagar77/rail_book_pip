import 'package:flutter/material.dart';
import 'package:rail_book_pip/controllers/exception_handling.dart';
import 'package:rail_book_pip/models/seatavailable.dart';
import 'package:rail_book_pip/models/train_searchrequest.dart';
import 'package:rail_book_pip/networkservices/search_train_service.dart';
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

  TrainSearchRequest trainAvailabilityParams;

  TrainSearchService _trainService = TrainSearchService();

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
                debugPrint('${snapshot.data}');
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return CustomErrorWidget(
                    errorMessage: snapshot.error.toString());
              } else {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    final train = snapshot.data?[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeatAvailabilityScreen(
                              seatAvailabilityParams: SeatAvailabilityParams(
                                  trainNo: train!.trainNumber,
                                  fromStationCode: train.from,
                                  toStationCode: train.to,
                                  date: train.trainDate,
                                  classType: trainAvailabilityParams.classType,
                                  quota: trainAvailabilityParams.quota),
                              myTrain: train,
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
                                '${train?.trainNumber} - ${train?.trainName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Run Days: ${train?.runDays.join(", ")}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Text(
                                'Source: ${train?.fromStationName} (${train?.from})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Departure: ${train?.fromStd}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Destination: ${train?.toStationName} (${train?.to})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Arrival: ${train?.toStd}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Text(
                                'Duration: ${train?.duration}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Train Type: ${train?.trainType}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Train Date: ${train?.trainDate}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Text(
                                'Classes Available: ${train?.classType.join(", ")}',
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
            future: _trainService.searchTrains(
              trainAvailabilityParams.fromStationCode,
              trainAvailabilityParams.toStationCode,
              trainAvailabilityParams.date,
            ),
          ),
        ));
  }
}
