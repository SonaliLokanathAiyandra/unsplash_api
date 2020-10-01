import 'package:flutter/material.dart';

import 'home.dart';
void main() {
  runApp(StartPage());
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}


