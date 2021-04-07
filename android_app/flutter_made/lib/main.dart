import 'package:flutter/material.dart';
import 'package:flutter_made/welcome.dart';
import 'package:flutter_made/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.green,
      ),
      home: WelcomeS(),
    );
  }

}
