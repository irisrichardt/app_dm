import 'package:flutter/material.dart';

const String apiBaseUrl = 'http://10.0.2.2:3001';

const Color customBlue = Color.fromARGB(255, 80, 114, 236);

InputDecoration inputDecoration(
    {required String labelText,
    required String hintText,
    required IconData icon}) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: customBlue),
    filled: true,
    fillColor: Colors.white.withOpacity(0.3),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: customBlue),
    ),
    labelText: labelText,
    labelStyle: TextStyle(color: customBlue),
    hintText: hintText,
    hintStyle: TextStyle(color: customBlue.withOpacity(0.5)),
  );
}
