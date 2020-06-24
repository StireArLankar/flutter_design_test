import 'package:flutter/material.dart';
import 'header.dart';

class SliverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Header(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
