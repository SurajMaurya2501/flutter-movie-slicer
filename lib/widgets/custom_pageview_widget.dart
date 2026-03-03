import 'package:flutter/material.dart';

class CustomPageViewWidget extends StatelessWidget {
  final String title;
  final String image;
  final String description;
  const CustomPageViewWidget({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Image.asset(
            image,
            height: 300,
            width: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 30),
          Text(
            description,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
