import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String image;
  final String title;
  const HomeCard({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      margin: EdgeInsets.only(top: 20),
      child: Card(child: Builder(builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: <Widget>[
                Image.asset(
                  image,
                  width: MediaQuery.of(context).size.width - 60,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
            ),
          ]),
        );
      })),
    );
  }
}
