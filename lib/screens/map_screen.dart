import 'package:flutter/material.dart';
class MapScreen extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF05070D), appBar: AppBar(title: Text("Coverage Map"), backgroundColor: Color(0xFF0A1428)),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Container(height:300, decoration: BoxDecoration(color: Color(0xFF0A1428), borderRadius: BorderRadius.circular(16)), child: Center(child: Text("Nakifuma 95%\nGirinya 92%\nMayangayanga 90%\nKawuku 91%\nNdwaddemutwe 88%", textAlign: TextAlign.center))),
        SizedBox(height:12), Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF0A1428), borderRadius: BorderRadius.circular(12)), child: Text("Nodes Online: 5/5 • Solar Charging ☀️")),
      ]),
    );
  }
}