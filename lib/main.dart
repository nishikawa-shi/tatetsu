import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

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

class InputParticipantsPage extends StatefulWidget {
  InputParticipantsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _InputParticipantsPageState createState() => _InputParticipantsPageState();
}

class _InputParticipantsPageState extends State<InputParticipantsPage> {
  final List<Participant> _participants = [
    Participant("Alice"),
    Participant("Bob")
  ];

  void _insertParticipantToLast() {
    setState(() {
      final displayName =
          ["Dr.", generateWordPairs().first.asUpperCase].join(" ");
      _participants.add(Participant(displayName));
    });
  }

  void _removeParticipant(int index) {
    setState(() {
      final participantsIndex = index - 1;
      _participants.removeAt(participantsIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("Enter participants names."));
              }
              if (index > _participants.length) {
                return Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: TextButton(
                      child: const Icon(Icons.add_circle_sharp, size: 40),
                      onPressed: _insertParticipantToLast,
                    ));
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: TextFormField(
                          initialValue: _participants[index - 1].displayName)),
                  IconButton(
                    icon: Icon(Icons.remove, size: 16),
                    onPressed: () {
                      _removeParticipant(index);
                    },
                  )
                ],
              );
            },
            itemCount: _participants.length + 2),
      ),
    );
  }
}

class Participant {
  String displayName;

  Participant(this.displayName);
}
