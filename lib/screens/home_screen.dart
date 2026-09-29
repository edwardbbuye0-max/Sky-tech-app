import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF05070D),
      appBar: AppBar(title: Text("SKY-TECH NAKIFUMA WIFI"), backgroundColor: Color(0xFF0A1428)),
      body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(children: [
        Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(border: Border.all(color: Color(0xFF7DD3FF)), borderRadius: BorderRadius.circular(16), color: Color(0xFF0A1428)),
          child: Column(children: [
            Row(children: [Icon(Icons.wifi, color: Color(0xFF7DD3FF)), Text(" WiFi Connected"), Spacer(), Container(padding: EdgeInsets.symmetric(horizontal:12, vertical:4), decoration: BoxDecoration(color: Color(0xFFFFEB3B), borderRadius: BorderRadius.circular(20)), child: Text("Yes", style: TextStyle(color: Colors.black)))]),
            SizedBox(height:16), Text("Remaining Time", style: TextStyle(color: Color(0xFF7DD3FF))), Text("02:34:12", style: TextStyle(fontSize:48, fontWeight: FontWeight.bold)), Text("Session countdown", style: TextStyle(fontSize:10)),
          ])),
        SizedBox(height:16),
        Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF0A1428), borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Speed Live Test", style: TextStyle(fontWeight: FontWeight.bold)), Text("125 Mbps", style: TextStyle(fontSize:42, color: Color(0xFF7DD3FF), fontWeight: FontWeight.bold)),
            Row(children: [ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFEB3B)), child: Text("Run Speed Test", style: TextStyle(color: Colors.black))), SizedBox(width:10), OutlinedButton(onPressed: (){}, child: Text("Pause Session"))]),
          ])),
      ])),
    );
  }
}