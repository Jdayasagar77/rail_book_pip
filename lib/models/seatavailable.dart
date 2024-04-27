
class SeatAvailability {
  final int ticketFare;
  final int cateringCharge;
  final String totalFare;
  final String date;
  final String? confirmProbabilityPercent;
  final String? confirmProbability;
  final String currentStatus;

  SeatAvailability({
    required this.ticketFare,
    required this.cateringCharge,
    required this.totalFare,
    required this.date,
    required this.confirmProbabilityPercent,
    required this.confirmProbability,
    required this.currentStatus,
  });

  factory SeatAvailability.fromJson(Map<String, dynamic> json) {
    return SeatAvailability(
      ticketFare: json['ticket_fare'],
      cateringCharge: json['catering_charge'],
      totalFare: json['total_fare'].toString(),
      date: json['date'],
      confirmProbabilityPercent: json['confirm_probability_percent'],
      confirmProbability: json['confirm_probability'],
      currentStatus: json['current_status'],
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
