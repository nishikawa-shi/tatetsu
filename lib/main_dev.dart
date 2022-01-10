import 'package:flutter/material.dart';
import 'package:tatetsu/ui/input_participants/input_participants_page.dart';

void main() {
  runApp(Tatetsu());
}

class Tatetsu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tatetsu Dev',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const InputParticipantsPage(title: '[Dev] Participants'),
    );
  }
}
