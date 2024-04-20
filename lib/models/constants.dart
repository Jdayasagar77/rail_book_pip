import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rail_book_pip/scoped.dart';

class ImageConstants {
  static final ImageConstants constants = ImageConstants._();
  factory ImageConstants() => constants;
  ImageConstants._();
dynamic convertToBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    return 'data:image/jpeg;base64,$base64Image';
  }
dynamic decodeBase64(String encoded) {
    String decoded = utf8.decode(base64Url.decode(encoded));
    return decoded;
  }
}

class UserModel extends Model {
  bool isLoading = false;
  static String? logged;

  // static UserModel of(BuildContext context) =>
  //     ScopedModel.of<UserModel>(context);

  static Map<String, dynamic> userData = <String, dynamic>{};

  @override
  void addListener(listener) {
    super.addListener(listener);
  }

   isLogged() {
    return logged != null && logged!.isNotEmpty;
  }
}

class Query {
  String? from;
  String? to;
  String? departure;
  String? returnDate;
  int? totalPassengers;
  Map<String, int>? passengers;

  Query(
      {this.from,
      this.to,
      this.departure,
      this.passengers,
      this.returnDate,
      this.totalPassengers});

  Query.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    departure = json['departure'];
    returnDate = json["returnDate"];
    passengers = json['passengers'];
    totalPassengers = json["totalPassengers"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    data['departure'] = departure;
    data["returnDate"] = returnDate;
    data["totalPassengers"] = totalPassengers;
    data['passengers'] = passengers;
    return data;
  }
}


 
class QueryModel extends Model {
  UserModel? userModel;
  Query? currentQuery;
  
 // static QueryModel of(BuildContext context) =>
  //    ScopedModel.of<QueryModel>(context);

  QueryModel({this.userModel, this.currentQuery});

  void setQuery(Query query) {
    currentQuery = query;

    notifyListeners();
  }

  Query? get query => currentQuery;
}
