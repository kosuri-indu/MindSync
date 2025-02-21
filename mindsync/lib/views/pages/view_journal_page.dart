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
      appBar: AppBar(
        title: Text('Journal Entry'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
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
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              child: Text(
                journal['content']!,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
