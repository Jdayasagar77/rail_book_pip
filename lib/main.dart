import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    home: BottomTabBarScreen(),
    );
  }
}

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
      appBar: AppBar(
        title: const Text('Bottom Tab Bar Example'),
      ),
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

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Home Tab Content',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}

class MyAccountTab extends StatelessWidget {
  const MyAccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'My Account Tab Content',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}

class MyTransactionsTab extends StatelessWidget {
  const MyTransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'My Transactions Tab Content',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
