import 'package:flutter/material.dart';

void main() {
  runApp(const MeuMobileApp());
}

class MeuMobileApp extends StatelessWidget {
  const MeuMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('MEÜ Mobile'),
        ),
      ),
    );
  }
}