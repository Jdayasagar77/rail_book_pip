
class SeatAvailability {
  final int ticketFare;
  final int cateringCharge;
  final String totalFare;
  final String date;
  final String confirmProbabilityPercent;
  final String confirmProbability;
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