import 'package:flutter/material.dart';
import 'home_screen.dart'; import 'buy_screen.dart'; import 'map_screen.dart'; import 'alerts_screen.dart';

class MainNav extends StatefulWidget { @override _MainNavState createState() => _MainNavState(); }
class _MainNavState extends State<MainNav> {
  int idx=0;
  final screens=[HomeScreen(), BuyScreen(), MapScreen(), AlertsScreen()];
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: screens[idx],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0A1428), selectedItemColor: Color(0xFFFFEB3B),
        unselectedItemColor: Colors.white60, currentIndex: idx, type: BottomNavigationBarType.fixed,
        onTap: (i)=>setState(()=>idx=i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: "Voucher"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Alerts"),
        ],
      ),
    );
  }
}