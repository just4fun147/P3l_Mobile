import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_auth/network/api.dart';
import '../api/network.dart';
import 'dart:convert';
import 'login_page.dart';
import 'home_page_guest.dart';
import 'page2.dart';
import 'page3.dart';
import 'search.dart';
import 'profile_page.dart';

class HomeGuest extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeGuest> {
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomePageGuest(),
    Page2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(
            'Grand Atma Hotel',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () => {},
            icon: Image.asset("lib/images/logo.png"),
          ),
          backgroundColor: Color(0xFF0C1738),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.login_outlined),
              onPressed: () {
                login();
              },
            )
          ],
        ),
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          selectedFontSize: 12.0,
          unselectedFontSize: 10.0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Explore',
            ),
          ],
        ));
  }

  void login() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    localStorage.remove('role');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
