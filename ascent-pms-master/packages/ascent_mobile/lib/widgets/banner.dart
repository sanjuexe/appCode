import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWithIndicator extends StatefulWidget {
  final List<Widget> items;
  const CarouselWithIndicator(this.items, {super.key});

  @override
  State<CarouselWithIndicator> createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int currentBanner = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (i, _) => setState(() => currentBanner = i),
          ),
          itemCount: widget.items.length,
          itemBuilder: (context, i, _) => widget.items[i],
        ),
        const SizedBox(height: 10),
        CarouselIndicator(
          color: Colors.grey,
          activeColor: Colors.black,
          height: 3,
          width: 7,
          count: widget.items.length,
          index: currentBanner,
        ),
      ],
    );
  }
}
