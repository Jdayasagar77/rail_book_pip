import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rail_book_pip/models/seatavailable.dart';

class SeatAvailabilityService {
  Future<List<SeatAvailability>> checkSeatAvailability(
      SeatAvailabilityParams seatAvailabilityParams) async {

    final Map<String, String> headers = {
      'X-RapidAPI-Key': '${dotenv.env["IRCTC_KEY"]}',
      'X-RapidAPI-Host': '${dotenv.env["IRCTC_HOST"]}',
    };

    final Map<String, String> queryParams = {
      'classType': seatAvailabilityParams.classType,
      'fromStationCode': seatAvailabilityParams.fromStationCode,
      'quota': seatAvailabilityParams.quota,
      'toStationCode': seatAvailabilityParams.toStationCode,
      'trainNo': seatAvailabilityParams.trainNo,
      'date': seatAvailabilityParams.date,
    };

    final Uri uri = Uri.parse("${dotenv.env["CHECK_SEAT_AVAILABILITY"]}").replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint('$responseData');

        if (responseData['status'] == true) {

          
          return responseData['data']
              .map<SeatAvailability>(
                  (seatData) => SeatAvailability.fromJson(seatData))
              .toList();
        } else {
          // Handle error message from the API
          throw Exception(
              'API error: ${responseData['message'] ?? 'Unknown error'}');
        }
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
