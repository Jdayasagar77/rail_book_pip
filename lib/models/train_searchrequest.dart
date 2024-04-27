

class TrainSearchRequest {
  
  final String classType;
  final String fromStationCode;
  final String quota;
  final String toStationCode;
  final String date;

  TrainSearchRequest({
    required this.classType,
    required this.fromStationCode,
    required this.quota,
    required this.toStationCode,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'classType': classType,
      'fromStationCode': fromStationCode,
      'quota': quota,
      'toStationCode': toStationCode,
      'date': date,
    };
  }
}
