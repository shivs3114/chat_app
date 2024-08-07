import 'dart:ui';

import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Color B_color;
  final VoidCallback onPressed;
  RoundedButton(
      {super.key,
      required this.title,
      this.B_color = Colors.blue,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: B_color,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
