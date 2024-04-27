
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rail_book_pip/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyTransactionsTab extends StatefulWidget {
  const MyTransactionsTab({super.key});


  @override
  State<MyTransactionsTab> createState() => _MyTransactionsTabState();
}

class _MyTransactionsTabState extends State<MyTransactionsTab> {

  
Future<List<TransactionModel>> myTransactions() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final docRef = await FirebaseFirestore.instance
      .collection("Users")
      .doc(prefs.getString('userUID'))
      .collection("transaction")
      .get();

  final List<TransactionModel> transactions = docRef.docs.map((doc) {
    return TransactionModel(
      name: doc.data()['name'],
      transactionID: doc.data()['transactionID'],
      amount: doc.data()['amount'],
      currentStatus: doc.data()['currentStatus'],
      trainName: doc.data()['trainName'],
      trainNo: doc.data()['trainNo'],
      date: doc.data()['date'],
    );
  }).toList();

  return transactions;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("My Transactions"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
      future: myTransactions(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            final transaction = snapshot.data?[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction!.name,
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text(
                          "Transaction ID: ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(transaction.transactionID),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text(
                          "Amount: ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          "\Rs.${transaction.amount}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text(
                          "Status: ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(transaction.currentStatus),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text(
                          "Train: ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(transaction.trainName),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text(
                          "Seat No: ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(transaction.currentStatus),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text(
                          "Date: ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          transaction.date,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      ),
    );
  }
}




