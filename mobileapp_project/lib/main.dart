import 'package:flutter/material.dart';
import 'package:mobileapp_project/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToiletApp',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        backgroundColor: Colors.grey
      ),
      home: const LoginPage(),
    );
  }
}