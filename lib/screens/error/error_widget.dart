import 'package:flutter/material.dart';

Widget errorWidget(String error, {VoidCallback? onPressed}) {
  return Column(
    children: [
      Text(error),
      ElevatedButton(
        onPressed: onPressed,
        child: Text('Retry'),
      ),
    ],
  );
}