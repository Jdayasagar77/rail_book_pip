import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rail_book_pip/models/station.dart';
import 'package:http/http.dart' as http;
import 'package:rail_book_pip/screens/train_search.dart';
import 'package:rail_book_pip/models/train_searchrequest.dart';


class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {

  TextEditingController _departurecontroller = TextEditingController();

  TextEditingController _fromstationController = TextEditingController();

  TextEditingController _tostationController = TextEditingController();

  List<Station> _stationsFrom = [];
  List<Station> _stationsTo = []; // Example station names
  

  Future<void> searchFromStations(String query) async {

    const String apiUrl = 'https://irctc1.p.rapidapi.com/api/v1/searchStation';
   
    final Map<String, String> headers = {
      'X-RapidAPI-Key': '5960234c6emsh2e935864ecc8378p110471jsn851268f65c1f',
      'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
    };

    final Uri uri = Uri.parse(apiUrl);
    final response = await http
        .get(uri.replace(queryParameters: {'query': query}), headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
              debugPrint('$responseData');

      if (responseData['status'] == true) {
                      debugPrint(' From Station : $responseData');
if (responseData['data'].isEmpty) {
debugPrint("No Stations Found yet");
} else {
_stationsFrom = List<Station>.from(responseData['data']
              .map((stationData) => Station.fromJson(stationData)));
            showFromStation();
}
      } else {
        // Handle error message from the API
                debugPrint('Error: ${responseData['message']}');
      }
    } else {

      // Handle HTTP error
      debugPrint('HTTP Error: ${response.statusCode}');

      // Handle HTTP error
      debugPrint('HTTP Error: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                        duration: const Duration(seconds: 5),
                        content:
                            Text('Error: ${response.body}'),
                            ),
        );
    }
  }

  Future<void> searchToStations(String query) async {

    const String apiUrl = 'https://irctc1.p.rapidapi.com/api/v1/searchStation';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': '5960234c6emsh2e935864ecc8378p110471jsn851268f65c1f',
      'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
    };

    final Uri uri = Uri.parse(apiUrl);
    final response = await http
        .get(uri.replace(queryParameters: {'query': query}), headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
              debugPrint(' To Station : $responseData');

      if (responseData['status'] == true) {

        if (responseData['data'].isEmpty) {
debugPrint("No Stations Found yet");
} else {
          _stationsTo = List<Station>.from(responseData['data']
              .map((stationData) => Station.fromJson(stationData)));
}
       showToStation();

      } else {

        // Handle error message from the API
        debugPrint('Error: ${responseData['message']}');
      }
    } else {
      // Handle HTTP error
      debugPrint('HTTP Error: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                        duration: const Duration(seconds: 5),
                        content:
                            Text('Error: ${response.body}')),
                  );
    }
  }

  String selectedFrom = '';
  String selectedTo = '';
  String selectedClass = '';
  String selectedQuota = '';

  onTapFunction({required BuildContext context}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      lastDate: DateTime.parse("2032-02-27"),
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    _departurecontroller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
  }

  List<String> classes = ['2A', 'SL', '2S']; // Example classes
  List<String> quotas = ['GN', 'LD', 'TQ']; // Example quotas

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                onChanged: (value) {
                    searchFromStations(value);
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
                        searchToStations(value);
          
                                      
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
                  const Text(
                    'Departure Date: ',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 255, 8),
                    ),
                  ),
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
                  const Text(
                    'Class: ',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 255, 8),
                    ),
                  ),
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
                  const Text(
                    'Quota: ',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 255, 8),
                    ),
                  ),
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
                onPressed: (){
                 
                  if (selectedClass.isNotEmpty &&
                      selectedFrom.isNotEmpty &&
                      selectedQuota.isNotEmpty &&
                      selectedTo.isNotEmpty &&
                      _departurecontroller.text.isNotEmpty) {

                    Navigator.push(
                        context,
                        MaterialPageRoute(
          
                            builder: (context) => TrainSearchScreen(trainAvailabilityParams: TrainSearchRequest(classType: selectedClass, fromStationCode: selectedFrom, quota: selectedQuota, toStationCode: selectedTo, date: _departurecontroller.text))));
                                
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill all fields Properly')),
                    );
                  }
                },
                child: const Text('Search'),
              ),
            ],
          ),
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
            itemCount: _stationsFrom.length,
            itemBuilder: (context, index) {
              final station = _stationsFrom[index];
              return _stationsFrom.isEmpty ? const ListTile(title: Text("No Stations Found Yet"),
                subtitle: Text("Search Again")) :
                ListTile(
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
            itemCount: _stationsTo.length,
            itemBuilder: (context, index) {
              final station = _stationsTo[index];
              return _stationsTo.isEmpty ? const ListTile(title: Text("No Stations Found Yet"),
                subtitle: Text("Search Again"),
                ) : ListTile(
                title: Text(station.name),
                subtitle: Text(station.stateName),
                trailing: Text(station.code),
                onTap: () {
                  setState(() {
                    selectedTo = station.code;
                    debugPrint(selectedTo);
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
                title: const Text('2A'),
                onTap: () {
                  setState(() {
                    selectedClass = '2A';
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
                    selectedQuota = 'GN';
                  });
                  Navigator.pop(context);
                },
              ),
              //['GN', 'LD', 'TQ']
              ListTile(
                title: const Text('Ladies'),
                onTap: () {
                  setState(() {
                    selectedQuota = 'LD';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Tatkal'),
                onTap: () {
                  setState(() {
                    selectedQuota = 'TQ';
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
