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
    'assets/images/angry_face.png',
    'assets/images/sad_face.png',
    'assets/images/med_face.png',
    'assets/images/happy_face.png',
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
      backgroundColor: Color(0xFFF5F5F5), 
      appBar: AppBar(
        title: Text(
            widget.initialJournal == null
                ? 'New Journal Entry'
                : 'Edit Journal Entry',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Mood:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: moodOptions.map((String mood) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = mood;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 2.0),
                        padding: const EdgeInsets.all(4.0), 
                        decoration: BoxDecoration(
                          color: selectedMood == mood
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.transparent,
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
                          width: 40, 
                          height: 40, 
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: journalController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Write your journal here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (journalController.text.isNotEmpty &&
                        selectedMood != null) {
                      Navigator.pop(context, {
                        'date': DateFormat.yMMMd().format(selectedDate),
                        'mood': selectedMood!,
                        'content': journalController.text,
                      });
                    }
                  },
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF9EB567), 
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
