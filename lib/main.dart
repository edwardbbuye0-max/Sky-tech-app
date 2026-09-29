import 'package:flutter/material.dart';
import 'screens/main_nav.dart';
void main() => runApp(SkyTechApp());
class SkyTechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SKY-TECH NAKIFUMA',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF05070D)),
      home: MainNav(),
      debugShowCheckedModeBanner: false,
    );
  }
}