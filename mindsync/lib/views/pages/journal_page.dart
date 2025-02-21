import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'enter_journal_page.dart';
import 'view_journal_page.dart';

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser {
    final user = _auth.currentUser;
    print('Current user ID: ${user?.uid}');
    return user;
  }

  /// ✅ Fetch journals from `users/{userId}/journals/`
  Stream<List<Map<String, dynamic>>> getUserJournals() {
    if (currentUser == null) {
      print("User not authenticated. Cannot fetch journals.");
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('journals') // ✅ Fetch from correct path
        .snapshots()
        .map((snapshot) {
      print('Fetched ${snapshot.docs.length} journals');
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    });
  }

  /// ✅ Store journal under `users/{userId}/journals/`
  Future<void> addJournal(Map<String, String> journal) async {
    if (currentUser == null) {
      print("User not authenticated. Cannot add journal.");
      return;
    }

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('journals') // ✅ Save inside user collection
        .add({
      'userId': currentUser!.uid,
      'date': journal['date'],
      'mood': journal['mood'],
      'content': journal['content'],
    });
  }

  /// ✅ Update journal at `users/{userId}/journals/{journalId}`
  Future<void> updateJournal(
      String id, Map<String, String> updatedJournal) async {
    if (currentUser == null) {
      print("User not authenticated. Cannot update journal.");
      return;
    }

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('journals') // ✅ Correct path for update
        .doc(id)
        .update({
      'date': updatedJournal['date'],
      'mood': updatedJournal['mood'],
      'content': updatedJournal['content'],
    });
  }

  /// ✅ Delete journal from `users/{userId}/journals/{journalId}`
  Future<void> deleteJournal(String id) async {
    if (currentUser == null) {
      print("User not authenticated. Cannot delete journal.");
      return;
    }

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('journals') // ✅ Correct path for delete
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Journals'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EnterJournalPage()),
              ).then((newJournal) {
                if (newJournal != null) {
                  addJournal(newJournal);
                }
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getUserJournals(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var journals = snapshot.data!;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: journals.length,
            itemBuilder: (context, index) {
              var journal = journals[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewJournalPage(
                        journal: journal.map(
                            (key, value) => MapEntry(key, value.toString())),
                        onDelete: () {
                          deleteJournal(journal['id'] ?? '').then((_) {
                            Navigator.pop(
                                context); // ✅ Return to JournalPage after delete
                          });
                        },
                        onEdit: (updatedJournal) {
                          updateJournal(journal['id'] ?? '', updatedJournal)
                              .then((_) {
                            Navigator.pop(
                                context); // ✅ Return to JournalPage after edit
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          journal['date'] ?? 'No Date',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        journal['mood'] != null
                            ? Image.asset(
                                journal['mood']!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            journal['content'] ?? 'No Content',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
