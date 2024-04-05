import 'package:flutter/material.dart';
import 'package:skupka_kradenogo/templates/tab_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomPageController(),
    );
  }
}
