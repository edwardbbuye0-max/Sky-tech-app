import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() => runApp(SkyTechApp());

class SkyTechApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark(), home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _remainingSeconds = 2*3600 + 34*60 + 12;
  bool _isPaused = false;
  Timer? _timer;
  double _speed = 0;
  bool _isTesting = false;
  double _progress = 0;

  @override
  void initState() { super.initState(); _startTimer(); }
  
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (!_isPaused && _remainingSeconds > 0) setState(() => _remainingSeconds--);
    });
  }

  String get _formattedTime {
    int h = _remainingSeconds ~/ 3600;
    int m = (_remainingSeconds % 3600) ~/ 60;
    int s = _remainingSeconds % 60;
    return "${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}";
  }

  Future<void> _runSpeedTest() async {
    setState(() { _isTesting = true; _speed = 0; _progress = 0; });
    try {
      var client = http.Client();
      var request = http.Request('GET', Uri.parse('https://speed.cloudflare.com/__down?bytes=25000000'));
      var response = client.send(request);
      int bytesReceived = 0;
      int totalBytes = 25000000;
      var stopwatch = Stopwatch()..start();
      var stream = await response;
      await for (var chunk in stream.stream) {
        bytesReceived += chunk.length;
        double prog = bytesReceived / totalBytes;
        double seconds = stopwatch.elapsedMilliseconds / 1000;
        if (seconds > 0) {
          double mbps = (bytesReceived * 8 / 1000000) / seconds;
          setState(() { _progress = prog; _speed = mbps; });
        }
      }
      stopwatch.stop();
      client.close();
    } catch (e) {
      setState(() => _speed = -1);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Offline: $e")));
    }
    setState(() => _isTesting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("SKY-TECH NAKIFUMA WIFI"), backgroundColor: Color(0xFF0D1B2A)),
      body: _selectedIndex == 0 ? _buildHome() : Center(child: Text("Voucher: SKY100, NAKIFUMA")),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0D1B2A), selectedItemColor: Colors.yellow,
        currentIndex: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i),
        items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"), BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: "Voucher")],
      ),
    );
  }

  Widget _buildHome() {
    return Padding(padding: EdgeInsets.all(16), child: Column(children: [
      Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(border: Border.all(color: Colors.lightBlueAccent), borderRadius: BorderRadius.circular(20), color: Color(0xFF0D1B2A)),
        child: Column(children: [
          Text("Remaining Time", style: TextStyle(color: Colors.lightBlue)),
          Text(_formattedTime, style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold)),
        ])),
      SizedBox(height:20),
      Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Color(0xFF132238), borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          Text("REAL Speed Test", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _speed == -1 ? Text("Offline", style: TextStyle(fontSize: 32, color: Colors.red)) : Text("${_speed.toStringAsFixed(1)} Mbps", style: TextStyle(fontSize: 42, color: Colors.lightBlueAccent, fontWeight: FontWeight.bold)),
          if (_isTesting) LinearProgressIndicator(value: _progress, backgroundColor: Colors.grey, color: Colors.yellow),
          SizedBox(height:16),
          ElevatedButton(onPressed: _isTesting ? null : _runSpeedTest, style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black), child: Text(_isTesting ? "Testing... ${(_progress*100).toInt()}%" : "Run REAL Speed Test")),
        ])),
    ]));
  }
}
