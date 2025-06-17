import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final String imgLocation;
  final String eventName;
  const CategoryIcon({
    super.key,
    required this.imgLocation,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          Image.asset(imgLocation, height: 40, width: 40),
          Text(
            eventName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
