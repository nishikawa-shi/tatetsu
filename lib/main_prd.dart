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
        primarySwatch: _tatetsuViolet,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const InputParticipantsPage(title: 'Participants'),
    );
  }

  static const MaterialColor _tatetsuViolet = MaterialColor(
    0xFF8489B6,
    {
      50: Color(0xFFF0F1F6),
      100: Color(0xFFDADCE9),
      200: Color(0xFFC2C4DB),
      300: Color(0xFFA9ACCC),
      400: Color(0xFF969BC1),
      500: Color(0xFF8489B6),
      600: Color(0xFF7C81AF),
      700: Color(0xFF7176A6),
      800: Color(0xFF676C9E),
      900: Color(0xFF54598E),
    },
  );
}
