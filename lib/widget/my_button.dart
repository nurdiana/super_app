import 'package:flutter/material.dart';

Widget myButton(BuildContext  context, VoidCallback function) {
  return ElevatedButton(
    onPressed: function,
    child: const Text('Counter Page'),
  );
}