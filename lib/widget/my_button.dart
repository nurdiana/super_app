import 'package:flutter/material.dart';

Widget myButton(String title, VoidCallback function) {
  return ElevatedButton(
    onPressed: function,
    child: Text(title),
  );
}