import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EnterJournalPage extends StatefulWidget {
  final Map<String, String>? initialJournal;

  EnterJournalPage({this.initialJournal});

  @override
  _EnterJournalPageState createState() => _EnterJournalPageState();
}

class _EnterJournalPageState extends State<EnterJournalPage> {
  final TextEditingController journalController = TextEditingController();
  String? selectedMood;
  DateTime selectedDate = DateTime.now();

  final List<String> moodOptions = [
    'assets/images/happy_face.png',
    'assets/images/sad_face.png',
    'assets/images/med_face.png',
    'assets/images/angry_face.png',
    'assets/images/laugh_face.png',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialJournal != null) {
      journalController.text = widget.initialJournal!['content']!;
      selectedMood = widget.initialJournal!['mood'];
      selectedDate = DateFormat.yMMMd().parse(widget.initialJournal!['date']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialJournal == null
            ? 'New Journal Entry'
            : 'Edit Journal Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: journalController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Write your journal here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Mood:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: moodOptions.map((String mood) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = mood;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedMood == mood
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      mood,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (journalController.text.isNotEmpty && selectedMood != null) {
                  Navigator.pop(context, {
                    'date': DateFormat.yMMMd().format(selectedDate),
                    'mood': selectedMood!,
                    'content': journalController.text,
                  });
                }
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9EB567), // Use primary color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
