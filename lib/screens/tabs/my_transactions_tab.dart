
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
        title:  const Text("My Transactions"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
      future: myTransactions(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            final transactionModel = snapshot.data?[index];
            return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transactionModel!.name,
                  style: const TextStyle(fontSize: 16.0,
                  fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Text(
                      'Transaction ID: '
                    ),
                    Text(transactionModel!.transactionID
                    ,
                      style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Text(
                      'Amount: '
                    ),
                    Text(transactionModel.amount,
                      style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Text(
                      'Status: '
                    ),
                    Text(transactionModel.currentStatus,
                      style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Text(
                      'Train: ',
                    ),
                    Expanded(
                      child: Text(
                        transactionModel.trainName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis, // Handle overflow
                      style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Text(
                      'Train No: ',
                      
                    ),
                    Text(transactionModel.trainNo,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Text(
                      'Date: ',
                    ),
                    Text(transactionModel.date,
                      style: TextStyle(fontWeight: FontWeight.bold)),
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




