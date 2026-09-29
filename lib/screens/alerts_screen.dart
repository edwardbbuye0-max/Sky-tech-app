import 'package:flutter/material.dart';
class AlertsScreen extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF05070D), appBar: AppBar(title: Text("Outage Alerts"), backgroundColor: Color(0xFF0A1428)),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFFFFEB3B), borderRadius: BorderRadius.circular(12)), child: Text("1 Active Outage", style: TextStyle(color: Colors.black))),
        SizedBox(height:12), Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Color(0xFF0A1428), borderRadius: BorderRadius.circular(12)), child: Text("Mayangayanga down - ETA 35min")),
      ]),
    );
  }
}