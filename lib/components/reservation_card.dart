import 'package:flutter/material.dart';
import '../pages/detailReservation.dart';

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
              ))
            ]),
          );
        })),
      ),
    );
  }
}
