import 'package:cocode/colors.dart';
import 'package:cocode/login/confirmation_number_page.dart';
import 'package:cocode/login/login_page.dart';
import 'package:cocode/tap_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
