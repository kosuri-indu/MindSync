import 'package:flutter/material.dart';
import 'enter_journal_page.dart';

class ViewJournalPage extends StatelessWidget {
  final Map<String, String> journal;
  final VoidCallback onDelete;
  final ValueChanged<Map<String, String>> onEdit;

  ViewJournalPage({
    required this.journal,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Set the background color
      appBar: AppBar(
        title: Text('Journal Entry'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnterJournalPage(
                    initialJournal: journal,
                  ),
                ),
              ).then((updatedJournal) {
                if (updatedJournal != null) {
                  onEdit(updatedJournal);
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.black),
            onPressed: onDelete,
          ),
        ],
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
                journal['date']!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Image.asset(
                journal['mood']!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    journal['content']!,
                    style: TextStyle(fontSize: 16),
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