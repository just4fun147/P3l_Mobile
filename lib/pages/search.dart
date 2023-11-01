import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_auth/network/api.dart';
import '../api/network.dart';
import 'dart:convert';
import 'login_page.dart';
import 'home_page.dart';

class Page4 extends StatefulWidget {
  final String start_date;
  final String end_date;
  final String adult;
  final String child;

  const Page4({
    super.key,
    required this.start_date,
    required this.end_date,
    required this.adult,
    required this.child,
  });
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Page4> {

  @override
  void initState() {
    super.initState();
    _loadData();
  }

    _loadData() async {
    var data = {};
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokens = localStorage.getString('token');
    var lenght = tokens!.length;
    var token = tokens.substring(1, lenght - 1);
    var res = await Network().post(data, 'authUser', token);
    var body = json.decode(res.body);

    if (body['OUT_STAT'] == "T") {
    } else {
      _showMsg(body['OUT_MESS']);
    }
  }
_showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
