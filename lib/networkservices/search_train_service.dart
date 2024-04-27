import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rail_book_pip/models/train_model.dart';

class TrainSearchService {

  Future<List<Train>> searchTrains(String fromStationCode, String toStationCode,
      String dateOfJourney) async {

    const baseUrl = 'https://irctc1.p.rapidapi.com/api/v3/trainBetweenStations';

    final url = Uri.parse(
        '$baseUrl?fromStationCode=$fromStationCode&toStationCode=$toStationCode&dateOfJourney=$dateOfJourney');

    final Map<String, String> headers = {
      'X-RapidAPI-Key': '5960234c6emsh2e935864ecc8378p110471jsn851268f65c1f',
      'X-RapidAPI-Host': 'irctc1.p.rapidapi.com',
    };

    try {
      final response = await http.get(url, headers: headers);

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
