import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final String type;
  final String price;
  final String total;

  const Detail({
    super.key,
    required this.type,
    required this.price,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Align(
                  alignment: Alignment.topLeft,
                  // child: Text("("+total+") " + type+" " ),
                  child: Text("(" + total + ")" + type),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Align(
                  alignment: Alignment.topRight,
                  // child: Text("("+total+") " + type+" " ),
                  child: Text(price),
                ),
              ),
            )
          ],
        ));
  }
}
