import 'package:flutter/material.dart';
import 'package:mobile/pages/home.dart';
import 'package:mobile/pages/page3.dart';
import '../pages/detailReservation.dart';
import '../api/network.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationCard extends StatelessWidget {
  final String id;
  final String date_start;
  final String date_end;
  final String adult;
  final String child;
  final String id_booking;
  final String status;
  const ReservationCard({
    super.key,
    required this.id,
    required this.date_start,
    required this.date_end,
    required this.adult,
    required this.child,
    required this.id_booking,
    required this.status,
  });

  _showMsg(msg, context) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailReservation(id: id)),
        );
      },
      child: Container(
        width: 400,
        margin: EdgeInsets.only(top: 20),
        child: Card(child: Builder(builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                    child: Text(id_booking,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
              ),
              Container(
                  child: Text("Start :" + date_start,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold))),
              Container(
                  child: Text("End   :" + date_end,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold))),
              Container(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(status == "0"
                              ? "Expired"
                              : status == "1" || status == "2"
                                  ? "Not Paid"
                                  : status == "3" || status == "4"
                                      ? "Paid"
                                      : status == "5"
                                          ? "Success"
                                          : "Cancel"),
                        ],
                      ),
                      Column(
                        children: [
                          (status == "1" ||
                                  status == "2" ||
                                  status == "3" ||
                                  status == "4"
                              ? TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green)),
                                  onPressed: () async {
                                    showAlertDialog(context);
                                  },
                                  child: Text(
                                    status == "4" || status == "2"
                                        ? "Cancel"
                                        : "Refund",
                                    style: TextStyle(color: Colors.black),
                                  ))
                              : Text(""))
                        ],
                      )
                    ],
                  )
                ],
              ))
            ]),
          );
        })),
      ),
    );
  }

  void _cancel(context) async {
    var data = {
      'id': id,
    };

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tokens = localStorage.getString('token');
    var lenght = tokens!.length;
    var token = tokens.substring(1, lenght - 1);
    var res = await Network().post(data, 'reservation/cancel', token);
    var body = json.decode(res.body);
    if (body['OUT_STAT'] == "T") {
      _showMsg(body['OUT_MESS'], context);

      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      _showMsg(body['OUT_MESS'], context);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Confirm"),
      onPressed: () async {
        _cancel(context);
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are You Sure Want To Cancel This Reservation?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
