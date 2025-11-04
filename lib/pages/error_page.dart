import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String error;

  const ErrorPage({required this.error, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error!'),
        backgroundColor: Colors.red,
      ),
      body: Text(error),
    );
  }
}
