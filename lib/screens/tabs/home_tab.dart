import 'package:flutter/material.dart';

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