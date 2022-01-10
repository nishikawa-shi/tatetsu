import 'package:flutter/material.dart';
import 'package:tatetsu/ui/input_participants/input_participants_page.dart';

void main() {
  runApp(Tatetsu());
}

class Tatetsu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tatetsu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const InputParticipantsPage(title: 'Participants'),
    );
  }
}
