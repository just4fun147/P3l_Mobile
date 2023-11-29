import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_auth/network/api.dart';
import '../api/network.dart';
import 'dart:convert';
import 'login_page.dart';
import 'home_page.dart';
import 'package:mobile/components/home_carousel.dart';
import 'package:mobile/components/home_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  String name = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);
    // var user = jsonDecode(localStorage.getString('token')!);

    if (user != null) {
      setState(() {
        name = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.asset(
                              "lib/images/logo.png",
                              width: 75.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(children: [
                        Row(
                          children: [
                            Text(
                              'Welcome back!',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${name}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ]),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              HomeCarousel(),
              HomeCard(
                  image: "lib/images/superior.jpg",
                  title: "Personal Reservation"),
              HomeCard(
                  image: "lib/images/double.jpg", title: "Group Reservation"),
              HomeCard(image: "lib/images/ballroom.jpg", title: "Meeting Room"),
            ],
          ),
        ),
      ),
    );
  }
}
