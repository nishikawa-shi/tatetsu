import 'package:flutter/material.dart';
import 'package:tatetsu/ui/input_participants/InputParticipantsPage.dart';

void main() {
  runApp(Tatetsu());
}

class Tatetsu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InputParticipantsPage(title: 'Input Participants'),
    );
  }
}
