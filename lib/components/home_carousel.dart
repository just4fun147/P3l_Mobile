import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeCarousel extends StatelessWidget {
  const HomeCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(height: 200.0),
        items: [1, 2, 3, 4].map((i) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: ClipRRect(
                child: Image.asset(
                  "lib/images/c${i}.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ));
        }).toList(),
      ),
    );
  }
}
