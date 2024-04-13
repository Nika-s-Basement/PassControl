import 'package:flutter/material.dart';
import 'package:skupka_kradenogo/constraints/colors.dart';
import 'package:skupka_kradenogo/templates/tab_bar.dart';
import 'package:skupka_kradenogo/utils/globals.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    fetchItems();
    return MaterialApp(
      theme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: CustomPageController(),
    );
  }
}
