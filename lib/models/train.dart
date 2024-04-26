
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:rail_book_pip/models/train_model.dart';

class TrainSearchScreen extends StatefulWidget {
  @override
  _TrainSearchScreenState createState() => _TrainSearchScreenState();
}

class _TrainSearchScreenState extends State<TrainSearchScreen> {
  Future<List<Train>> searchTrains(String query) async {
    final String apiUrl = 'https://irctc1.p.rapidapi.com/api/v1/searchTrain';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': '1de23605f5msh6e24f587c98de99p1692ccjsnec101976d820',
      'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
    };

    final Uri uri = Uri.parse(apiUrl);
    final response = await http.get(uri.replace(queryParameters: {'query': query}), headers: headers);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == true) {
        List<Train> trains = responseData['data'].map<Train>((trainData) => Train.fromJson(trainData)).toList();
        return trains;
      } else {
        // Handle error message from the API
        print('Error: ${responseData['message']}');
        return [];
      }
    } else {
      // Handle HTTP error
      print('HTTP Error: ${response.statusCode}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IRCTC Train Search'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            List<Train> trains = await searchTrains('190');
            print(trains);
          },
          child: Text('Search Trains'),
        ),
      ),
    );
  }
}

