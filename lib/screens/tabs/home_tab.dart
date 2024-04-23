import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rail_book_pip/models/station.dart';
import 'package:http/http.dart' as http;

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  TextEditingController _departurecontroller = TextEditingController();

  TextEditingController _fromstationController = TextEditingController();

  TextEditingController _tostationController = TextEditingController();

  TextEditingController _classcontroller = TextEditingController();

  TextEditingController _qoutaController = TextEditingController();
  List<Station> _stations = [];
  List<String> stations = ['Station A', 'Station B', 'Station C']; // Example station names

  Future<void> searchStations(String query) async {
    final String apiUrl = 'https://irctc1.p.rapidapi.com/api/v1/searchStation';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': 'fdfaa3f240msha4a25388edb9d58p1da62djsn825aa66b0040',
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
      appBar: AppBar(
        title: const Text('IRCTC Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              onChanged: (value) {
                                searchStations(value);
                setState(() {
                  selectedFrom = value;
                                  showFromStation();
                });
              },
              controller: _fromstationController,
              decoration: const InputDecoration(
                labelText: 'From',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              onChanged: (value) {
                               searchStations(value);
                setState(() {
                  selectedFrom = value;
                                  showToStation();
                });
              },
              controller: _tostationController,
              decoration: const InputDecoration(
                labelText: 'To',
                border: OutlineInputBorder(),
              ),
            ),


            const SizedBox(height: 12.0),
            Column(
              children: [
                const Text('Departure Date: '),
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
                      border: OutlineInputBorder(),
                      hintText: "Departure Date",
                      hintStyle:
                          TextStyle(color: Color(0xFFb2b7bf), fontSize: 12.0)),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                const Text('Class: '),
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
                const Text('Quota: '),
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
              onPressed: () {
                // Perform search operation
                print('Searching...');
                print('From: $selectedFrom');
                print('To: $selectedTo');
                print('Class: $selectedClass');
                print('Quota: $selectedQuota');
              },
              child: const Text('Search'),
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
                itemCount: stations.length,
                itemBuilder: (context, index) {
                  final station = stations[index];
                  return ListTile(
                    title: Text(station),
                    // subtitle: Text(station.stateName),
                    // trailing: Text(station.code),
                    onTap: () {
                  setState(() {
                    _tostationController.text = station;
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
