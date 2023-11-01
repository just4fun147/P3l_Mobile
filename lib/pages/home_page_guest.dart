import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_auth/network/api.dart';
import '../api/network.dart';
import 'dart:convert';
import 'login_page.dart';
import 'home_page.dart';
import 'package:mobile/components/home_carousel.dart';
import 'package:mobile/components/home_card.dart';

class HomePageGuest extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePageGuest> {
  String name = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
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
