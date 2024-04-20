import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImagePost extends StatelessWidget {
  final String text;
  final String url;

  const ImagePost({super.key, required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.indigo.shade100,
      ),
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Image.network(
              url,
              fit: BoxFit.cover,
            ),
          ),
          Text(text),
        ],
      ),
    );
  }
}
