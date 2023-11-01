import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_auth/network/api.dart';
import '../../api/network.dart';
import 'dart:convert';
import '../login_page.dart';
import '../home_page.dart';
import '../profile_page.dart';

class HomeOwner extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeOwner> {
  String name = '';
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);

    if (user != null) {
      setState(() {
        name = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(
            'Grand Atma Hotel/Owner',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: () => {setState(() => _selectedIndex = 0)},
            icon: Image.asset("lib/images/logo.png"),
          ),
          backgroundColor: Color(0xFF0C1738),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                logout();
              },
            )
          ],
        ),
        body: _widgetOptions[_selectedIndex],
        // SingleChildScrollView(
        //   child: SafeArea(
        //     child: Container(
        //       padding: EdgeInsets.all(15),
        //       child: Column(
        //         children: [
        //           Row(
        //             children: [
        //               Text(
        //                 'Hello, ',
        //                 style: TextStyle(
        //                   fontSize: 20,
        //                 ),
        //               ),
        //               Text(
        //                 '${name}',
        //                 style: TextStyle(
        //                     fontSize: 20, fontWeight: FontWeight.bold),
        //               ),
        //             ],
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
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
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_sharp),
              label: 'Profile',
            ),
          ],
        ));
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    localStorage.remove('role');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
