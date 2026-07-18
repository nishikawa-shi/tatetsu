import 'package:flutter/material.dart';
import 'package:tatetsu/model/entity/participant.dart';

class ParticipantComponent {
  final String defaultDisplayName;
  final TextEditingController displayNameController = TextEditingController();

  ParticipantComponent(Participant participant)
      : defaultDisplayName = participant.displayName;

  String get displayName => displayNameController.text.isNotEmpty
      ? displayNameController.text
      : defaultDisplayName;

  void dispose() {
    displayNameController.dispose();
  }
}
