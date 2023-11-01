import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/home.dart';
import './pages/home_guest.dart';
import './pages/Owner/home_owner.dart';
import './pages/GM/home_gm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  String role = "";

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      if (mounted) {
        var roles = localStorage.getString('role');
        var lenght = roles!.length;
        var role = roles.substring(1, lenght - 1);
        setState(() {
          isAuth = true;
          role = role;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      if (role == "865fd661-ca01-44f6-866d-b44773740791") {
        child = Home();
      } else if (role == "4c8ad9bf-3168-4c16-ad64-dc0cfab73dc7") {
        // owner
        child = HomeOwner();
      } else if (role == "5616fc68-f5a3-4ce2-bfc5-a6d4f3cc6526") {
        // GM
        child = HomeGM();
      } else {
        child = LoginPage();
      }
    } else {
      child = HomeGuest();
    }

    return Scaffold(
      body: child,
    );
  }
}
