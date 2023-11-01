import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  final String price;

  const Summary({
    super.key,
    required this.price,
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
                  child: Text("Total"),
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
