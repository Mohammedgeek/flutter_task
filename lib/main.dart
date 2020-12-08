import 'package:flutter/material.dart';
import 'package:task_project/modules/deals_screen/deals.dart';
import 'package:task_project/modules/favorites_screen/favorites_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DealsScreen(),
      debugShowCheckedModeBanner: false,
    );

  }
}

