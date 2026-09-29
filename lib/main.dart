import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(SkyTechApp());

class SkyTechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _remainingSeconds = 2*3600 + 34*60 + 12; // 02:34:12
  bool _isPaused = false;
  Timer? _timer;
  double _speed = 125;
  bool _isTesting = false;
  String _voucherMessage = "";
  TextEditingController _voucherController = TextEditingController();

  Map<String, int> _validVouchers = {
    "SKY100": 3600, "NAKIFUMA": 7200, "WIFI2024": 1800, "FREE1H": 3600
  };

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (!_isPaused && _remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      }
    });
  }

  String get _formattedTime {
    int h = _remainingSeconds ~/ 3600;
    int m = (_remainingSeconds % 3600) ~/ 60;
    int s = _remainingSeconds % 60;
    return "${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}";
  }

  void _runSpeedTest() async {
    setState(() => _isTesting = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _speed = 50 + Random().nextInt(150).toDouble();
      _isTesting = false;
    });
  }

  void _redeemVoucher() {
    String code = _voucherController.text.trim().toUpperCase();
    if (_validVouchers.containsKey(code)) {
      setState(() {
        _remainingSeconds += _validVouchers[code]!;
        _voucherMessage = "Success! Added ${_validVouchers[code]! ~/ 3600} hour(s)";
        _voucherController.clear();
      });
    } else {
      setState(() => _voucherMessage = "Invalid voucher code!");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [_buildHome(), _buildVoucher(), _buildMap(), _buildAlerts()];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("SKY-TECH NAKIFUMA WIFI"), backgroundColor: Color(0xFF0D1B2A)),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0D1B2A),
        selectedItemColor: Colors.yellow, unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: "Voucher"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Alerts"),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(border: Border.all(color: Colors.lightBlueAccent), borderRadius: BorderRadius.circular(20), color: Color(0xFF0D1B2A)),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [Icon(Icons.wifi, color: Colors.lightBlue), SizedBox(width:8), Text("WiFi Connected")]),
              Container(padding: EdgeInsets.symmetric(horizontal:16, vertical:6), decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(20)), child: Text("Yes", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))
            ]),
            SizedBox(height:16),
            Text("Remaining Time", style: TextStyle(color: Colors.lightBlue)),
            Text(_formattedTime, style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold)),
            Text("Session countdown", style: TextStyle(color: Colors.grey)),
          ]),
        ),
        SizedBox(height:20),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Color(0xFF132238), borderRadius: BorderRadius.circular(20)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Speed Live Test", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${_speed.toStringAsFixed(0)} Mbps", style: TextStyle(fontSize: 42, color: Colors.lightBlueAccent, fontWeight: FontWeight.bold)),
            SizedBox(height:10),
            Row(children: [
              ElevatedButton(
                onPressed: _isTesting? null : _runSpeedTest,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black, shape: StadiumBorder()),
                child: Text(_isTesting? "Testing..." : "Run Speed Test"),
              ),
              SizedBox(width:12),
              OutlinedButton(
                onPressed: () => setState(() => _isPaused =!_isPaused),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.purpleAccent, side: BorderSide(color: Colors.grey), shape: StadiumBorder()),
                child: Text(_isPaused? "Resume Session" : "Pause Session"),
              ),
            ])
          ]),
        )
      ]),
    );
  }

  Widget _buildVoucher() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(children: [
        SizedBox(height:20),
        Text("Enter Voucher Code", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height:20),
        TextField(controller: _voucherController, decoration: InputDecoration(hintText: "e.g. SKY100", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Color(0xFF1A2C42)), textCapitalization: TextCapitalization.characters),
        SizedBox(height:16),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _redeemVoucher, style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black, padding: EdgeInsets.symmetric(vertical:14)), child: Text("REDEEM VOUCHER", style: TextStyle(fontWeight: FontWeight.bold)))),
        SizedBox(height:16),
        Text(_voucherMessage, style: TextStyle(color: _voucherMessage.contains("Success")? Colors.greenAccent : Colors.redAccent, fontSize: 16)),
        SizedBox(height:30),
        Text("Test codes: SKY100, NAKIFUMA, WIFI2024, FREE1H", style: TextStyle(color: Colors.grey)),
      ]),
    );
  }

  Widget _buildMap() => Center(child: Text("Map - Hotspots near Nakifuma"));
  Widget _buildAlerts() => Center(child: Text("No alerts"));
}
