class Train {
  final String trainNumber;
  final String trainName;
  final List<String> runDays;
  final String trainSrc;
  final String trainDstn;
  final String fromStd;
  final String fromSta;
  final int localTrainFromSta;
  final String toSta;
  final String toStd;
  final int fromDay;
  final int toDay;
  final int dDay;
  final String from;
  final String to;
  final String fromStationName;
  final String toStationName;
  final String duration;
  final bool specialTrain;
  final String trainType;
  final String trainDate;
  final List<String> classType;

  Train({
    required this.trainNumber,
    required this.trainName,
    required this.runDays,
    required this.trainSrc,
    required this.trainDstn,
    required this.fromStd,
    required this.fromSta,
    required this.localTrainFromSta,
    required this.toSta,
    required this.toStd,
    required this.fromDay,
    required this.toDay,
    required this.dDay,
    required this.from,
    required this.to,
    required this.fromStationName,
    required this.toStationName,
    required this.duration,
    required this.specialTrain,
    required this.trainType,
    required this.trainDate,
    required this.classType,
  });

  factory Train.fromJson(Map<String, dynamic> json) {
    return Train(
      trainNumber: json['train_number'],
      trainName: json['train_name'],
      runDays: List<String>.from(json['run_days']),
      trainSrc: json['train_src'],
      trainDstn: json['train_dstn'],
      fromStd: json['from_std'],
      fromSta: json['from_sta'],
      localTrainFromSta: json['local_train_from_sta'],
      toSta: json['to_sta'],
      toStd: json['to_std'],
      fromDay: json['from_day'],
      toDay: json['to_day'],
      dDay: json['d_day'],
      from: json['from'],
      to: json['to'],
      fromStationName: json['from_station_name'],
      toStationName: json['to_station_name'],
      duration: json['duration'],
      specialTrain: json['special_train'],
      trainType: json['train_type'],
      trainDate: json['train_date'],
      classType: List<String>.from(json['class_type']),
    );
  }
}



class SeatAvailabilityParams {
  final String trainNo;
  final String fromStationCode;
  final String toStationCode;
  final String date;
  final String classType; // Optional class type
  final String quota; // Optional quota

  SeatAvailabilityParams({
    required this.trainNo,
    required this.fromStationCode,
    required this.toStationCode,
    required this.date,
    required this.classType,
    required this.quota,
  });

  factory SeatAvailabilityParams.fromJson(Map<String, dynamic> json) =>
      SeatAvailabilityParams(
        trainNo: json['trainNo'] as String,
        fromStationCode: json['fromStationCode'] as String,
        toStationCode: json['toStationCode'] as String,
        date: json['date'] as String,
        classType: json['classType'] as String,
        quota: json['quota'] as String,
      );

  Map<String, dynamic> toJson() => {
        'trainNo': trainNo,
        'fromStationCode': fromStationCode,
        'toStationCode': toStationCode,
        'date': date,
        'classType': classType,
        'quota': quota,
      };
}
