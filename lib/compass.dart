import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

class Compass extends StatefulWidget {
  const Compass({super.key});

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  double _heading = 0;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    // Listen to sensor updates
    _streamSubscriptions.add(
      magnetometerEventStream().listen(
        (MagnetometerEvent event) {
          setState(
            () {
              _heading = atan2(event.y, event.x) * (180 / pi);
              if (_heading < 0) _heading += 360;
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compass')),
      body: Center(
        child: Transform.rotate(
          angle: (_heading * pi / 180) * -1,
          child: const Icon(
            Icons.navigation,
            size: 200,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}