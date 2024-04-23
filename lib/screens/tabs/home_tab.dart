import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rail_book_pip/models/seatavailable.dart';
import 'package:rail_book_pip/models/station.dart';
import 'package:http/http.dart' as http;
import 'package:rail_book_pip/screens/seat_availability.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {

  TextEditingController _departurecontroller = TextEditingController();

  TextEditingController _fromstationController = TextEditingController();

  TextEditingController _tostationController = TextEditingController();

  List<Station> _stations = [];
  List<String> stations = [
    'Station A',
    'Station B',
    'Station C'
  ]; // Example station names

  List<String> _trainNumbers = [];
  List<String> _trainName = [];

  Future<void> searchTrains() async {
    String fromStationCode = selectedFrom;
    String toStationCode = selectedTo;
    String dateOfJourney = _departurecontroller.text;

    String url = 'https://irctc1.p.rapidapi.com/api/v3/trainBetweenStations';
    Map<String, String> queryParams = {
      'fromStationCode': fromStationCode,
      'toStationCode': toStationCode,
      'dateOfJourney': dateOfJourney,
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    Map<String, String> headers = {
      'X-RapidAPI-Key': '5960234c6emsh2e935864ecc8378p110471jsn851268f65c1f',
      'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
    };

    try {
      http.Response response = await http.get(uri, headers: headers);
              final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Handle the response data as needed
        List<String> trainNumbers =
            responseData['data'].map((train) => train["train_number"]).toList();
        _trainNumbers = trainNumbers;
         List<String> trainName =
            responseData['data'].map((train) => train["train_name"]).toList();
        _trainName = trainName;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> searchStations(String query) async {
    final String apiUrl = 'https://irctc1.p.rapidapi.com/api/v1/searchStation';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': '5960234c6emsh2e935864ecc8378p110471jsn851268f65c1f',
      'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
    };

    final Uri uri = Uri.parse(apiUrl);
    final response = await http
        .get(uri.replace(queryParameters: {'query': query}), headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == true) {
        setState(() {
          _stations = List<Station>.from(responseData['data']
              .map((stationData) => Station.fromJson(stationData)));
        });
      } else {
        // Handle error message from the API

        debugPrint('Error: ${responseData['message']}');
      }
    } else {
      // Handle HTTP error
      debugPrint('HTTP Error: ${response.statusCode}');
    }
  }

  String selectedFrom = '';
  String selectedTo = '';
  String selectedClass = '';
  String selectedQuota = '';

  onTapFunction({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.now(),
      firstDate: DateTime(2015),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    _departurecontroller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
  }

  List<String> classes = ['AC', 'SL', '2S']; // Example classes
  List<String> quotas = ['GEN', 'Ladies', 'Tatkal']; // Example quotas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 138, 129, 129),
      appBar: AppBar(
        title: const Text('IRCTC Search'),
        leading: null,
                automaticallyImplyLeading: false,

      ),
      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              
              onChanged: (value) {
                setState(() {
                  searchStations(value);
                });
                if (_stations.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Unable to fetch data due a network error')),
                  );
                } else {
                  showFromStation();
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Station';
                }
                return null;
              },
              controller: _fromstationController,

              cursorColor: Colors.yellow,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.navigate_before_rounded),
                labelText: 'From',
              
                labelStyle: TextStyle(
color: Colors.yellow,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              onChanged: (value) {
                if (_stations.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        duration: Duration(seconds: 5),
                        content:
                            Text('Unable to fetch data due a network error')),
                  );
                } else {
                  showToStation();
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Station';
                }
                return null;
              },
              controller: _tostationController,
              decoration: const InputDecoration(
                 labelStyle: TextStyle(
color: Colors.yellow,
                ),
                                prefixIcon: Icon(Icons.location_on),
                labelText: 'To',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            Column(
              children: [
                const Text('Departure Date: ', style: TextStyle(
                  color: Color.fromARGB(255, 0, 255, 8),
                ),),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  readOnly: true,
                  onTap: () {
                    onTapFunction(context: context);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Date';
                    }
                    return null;
                  },
                  controller: _departurecontroller,
                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.calendar_month),

                      border: OutlineInputBorder(),
                      
                      hintText: "Departure Date",
                      hintStyle:
                          TextStyle(color: Colors.yellow, fontSize: 12.0)),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Text('Class: ', style: TextStyle(
                                    color: Color.fromARGB(255, 0, 255, 8),

                ),),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {
                    showClassPicker();
                  },
                  child: Text(
                      selectedClass.isEmpty ? 'Select Class' : selectedClass),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Text('Quota: ', style: TextStyle(
                                    color: Color.fromARGB(255, 0, 255, 8),

                ),),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {
                    showQuotaPicker();
                  },
                  child: Text(
                      selectedQuota.isEmpty ? 'Select Quota' : selectedQuota),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () async {
                if (selectedClass.isNotEmpty &&
                    selectedFrom.isNotEmpty &&
                    selectedQuota.isNotEmpty &&
                    selectedTo.isNotEmpty &&
                    _departurecontroller.text.isNotEmpty) {
                  searchTrains();
                  debugPrint('$_trainName');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeatAvailabilityScreen(
                                seatAvailabilityParams: SeatAvailabilityParams(
                                    classType: selectedClass,
                                    fromStationCode: selectedFrom,
                                    date: _departurecontroller.text,
                                    toStationCode: selectedTo,
                                    quota: selectedQuota,
                                    trainNo: _trainNumbers), trainName: _trainName,
                              )));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please fill all fields Properly')),
                  );
                }
              },
              child: const Text('Search'),
            ),
             const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () async {
            final offlineTo = 'BVI';
                        final offlineFrom = 'ST';
    final String response = await rootBundle.loadString('assets/json/train.json');
  List<String> trainNumbers = jsonDecode(response)["data"]
      .map<String>((train) => train["train_number"].toString())
      .toList();
        List<String> trainName = jsonDecode(response)["data"]
      .map<String>((train) => train["train_name"].toString())
      .toList();
debugPrint('$trainName');
debugPrint('$trainNumbers');

   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeatAvailabilityScreen(
                                seatAvailabilityParams: SeatAvailabilityParams(
                                    classType: selectedClass,
                                    fromStationCode: offlineFrom,
                                    date: _departurecontroller.text,
                                    toStationCode: offlineTo,
                                    quota: selectedQuota,
                                    trainNo: trainNumbers), trainName: trainName,
                              )));

              
              },
              child: const Text('Search on Offline Data'),
            ),
          ],
        ),
      ),
    );
  }

  void showFromStation() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: ListView.builder(
            itemCount: _stations.length,
            itemBuilder: (context, index) {
              final station = _stations[index];
              return ListTile(
                title: Text(station.name),
                subtitle: Text(station.stateName),
                trailing: Text(station.code),
                onTap: () {
                  setState(() {
                    selectedFrom = station.code;
                    _fromstationController.text = station.name;
                    Navigator.pop(context);
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  void showToStation() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: ListView.builder(
            itemCount: _stations.length,
            itemBuilder: (context, index) {
              final station = _stations[index];
              return ListTile(
                title: Text(station.name),
                subtitle: Text(station.stateName),
                trailing: Text(station.code),
                onTap: () {
                  setState(() {
                    selectedTo = station.code;
                    _tostationController.text = station.name;
                    Navigator.pop(context);
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  void showClassPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: [
              ListTile(
                title: const Text('AC'),
                onTap: () {
                  setState(() {
                    selectedClass = 'AC';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('SL'),
                onTap: () {
                  setState(() {
                    selectedClass = 'SL';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('2S'),
                onTap: () {
                  setState(() {
                    selectedClass = '2S';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showQuotaPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: [
              ListTile(
                title: const Text('GEN'),
                onTap: () {
                  setState(() {
                    selectedQuota = 'GEN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Ladies'),
                onTap: () {
                  setState(() {
                    selectedQuota = 'Ladies';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Tatkal'),
                onTap: () {
                  setState(() {
                    selectedQuota = 'Tatkal';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
