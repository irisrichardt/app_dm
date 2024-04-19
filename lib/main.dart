import 'package:app_dm/screens/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}
