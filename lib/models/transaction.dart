
class Transaction {
  final String name;
  final double amount;
  final String transactionId;
  final String currentStatus;
  final String trainName;
  final int no;
  final DateTime date;

  Transaction({
    required this.name,
    required this.amount,
    required this.currentStatus,
    required this.trainName,
    required this.no,
    required this.date,
    required this.transactionId,

  });
}

class TransactionModel {
  final String name;
  final String transactionID;
  final String amount;
  final String currentStatus;
  final String trainName;
  final String trainNo;
  final String date;

  TransactionModel({
    required this.name,
    required this.transactionID,
    required this.amount,
    required this.currentStatus,
    required this.trainName,
    required this.trainNo,
    required this.date,
  });
}