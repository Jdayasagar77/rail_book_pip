import 'dart:math';

class Transaction {
  final String name;
  final double amount;
  final String transactionId;
  final String currentStatus;
  final String classType;
  final String trainName;
  final int no;
  final DateTime date;

  Transaction({
    required this.name,
    required this.amount,
    required this.currentStatus,
    required this.classType,
    required this.trainName,
    required this.no,
    required this.date,
        required this.transactionId,

  });

  
}