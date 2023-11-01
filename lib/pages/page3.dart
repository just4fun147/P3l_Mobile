import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_auth/network/api.dart';
import '../api/network.dart';
import 'dart:convert';
import 'login_page.dart';
import 'home_page.dart';
import '../components/reservation_card.dart';

class Page3 extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Page3> {
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  var unpaid = [];
  var paid = [];
  var list = [];
  var finsihed = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadReservation();
  }

  _loadReservation() async {
    _isLoading = true;
    var dataUnpaid = {
      "id": null,
      "search": null,
      "is_group": false,
      "is_open": true,
      "is_paid": false
    };
    var dataPaid = {
      "id": null,
      "search": null,
      "is_group": false,
      "is_open": true,
      "is_paid": true
    };
    var dataFinished = {
      "id": null,
      "search": null,
      "is_group": false,
      "is_open": false,
      "is_paid": false
    };
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokens = localStorage.getString('token');
    var lenght = tokens!.length;
    var token = tokens.substring(1, lenght - 1);
    var resUnpaid = await Network().post(dataUnpaid, 'reservation', token);
    var resPaid = await Network().post(dataPaid, 'reservation', token);
    var resFinished = await Network().post(dataFinished, 'reservation', token);
    var bodyUnpaid = json.decode(resUnpaid.body);
    var bodyPaid = json.decode(resPaid.body);
    var bodyFinished = json.decode(resFinished.body);

    if (bodyFinished['OUT_STAT'] == "T") {
      var unpaids = bodyUnpaid['OUT_DATA']['data'].toList();
      var paids = bodyPaid['OUT_DATA']['data'].toList();
      var finsiheds = bodyFinished['OUT_DATA']['data'].toList();
      setState(() {
        unpaid = unpaids;
        paid = paids;
        finsihed = finsiheds;
        list = [...unpaid, ...paid, ...finsihed];
        _isLoading = false;
      });
    } else {
      _showMsg("Something Went Wrong!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(children: <Widget>[
          const SizedBox(height: 25),
          _isLoading
              ? Center(
                  child: Text("Loading..."),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return ReservationCard(
                            date_start: list[index]['start_date'],
                            id: list[index]['id'].toString(),
                            date_end: list[index]['end_date'],
                            adult: list[index]['adult'].toString(),
                            child: list[index]['child'].toString(),
                            id_booking: list[index]['id_booking'],
                            status: list[index]['status'].toString());
                      }),
                ),
        ]),
      ),
    );
  }
}
