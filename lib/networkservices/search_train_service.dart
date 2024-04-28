import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rail_book_pip/models/train_model.dart';

class TrainSearchService {

  Future<List<Train>> searchTrains(String fromStationCode, String toStationCode,
      String dateOfJourney) async {



    final url = Uri.parse(
        '${dotenv.env["TRAIN_BTW_STN"]}?fromStationCode=$fromStationCode&toStationCode=$toStationCode&dateOfJourney=$dateOfJourney');

    final Map<String, String> headers = {
       'X-RapidAPI-Key': '${dotenv.env["IRCTC_KEY"]}',
      'X-RapidAPI-Host': '${dotenv.env["IRCTC_HOST"]}',
    };

    try {

      final response = await http.get(url, headers: headers);
      //  debugPrint(response as String?);

      if (response.statusCode == 200) {
        //Handle the response data as needed
        final responseData = jsonDecode(response.body);

        return List<Train>.from(
            responseData['data'].map((trainData) => Train.fromJson(trainData)));
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      // Handle Socket Exceptions (e.g., internet issues)
      throw Exception('Error connecting to server: $e');
    } on FormatException catch (e) {
      // Handle JSON format errors
      throw Exception('Invalid server response format: $e');
    } catch (e) {
      // Handle other exceptions
      throw Exception('An unexpected error occurred: $e');
    }
  }

}
