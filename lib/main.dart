import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.pink[50],
      body: Center(
        child: Text(
          "Heartbeat App",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ));
}