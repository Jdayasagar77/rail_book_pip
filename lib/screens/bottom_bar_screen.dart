
import 'package:flutter/material.dart';
import 'package:rail_book_pip/screens/tabs/home_tab.dart';
import 'package:rail_book_pip/screens/tabs/my_account_tab.dart';
import 'package:rail_book_pip/screens/tabs/my_transactions_tab.dart';

class BottomTabBarScreen extends StatefulWidget {
  const BottomTabBarScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomTabBarScreenState createState() => _BottomTabBarScreenState();
}

class _BottomTabBarScreenState extends State<BottomTabBarScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const MyAccountTab(),
    const MyTransactionsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Bottom Tab Bar Example'),
      // ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'My Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Transactions',
          ),
        ],
      ),
    );
  }
}



