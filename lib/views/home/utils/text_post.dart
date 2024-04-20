import 'package:flutter/material.dart';

class TextPost extends StatelessWidget {
  final String text;
  const TextPost({super.key, required this.text});

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
      child: Text(text),
    );
  }
}
