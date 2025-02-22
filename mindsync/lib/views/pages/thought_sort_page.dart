import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mindsync/data/colors.dart';

typedef OnThoughtTap = void Function(String);

void main() {
  runApp(MaterialApp(
    home: ThoughtSortingGame(),
  ));
}

class ThoughtSortingGame extends StatefulWidget {
  @override
  _ThoughtSortingGameState createState() => _ThoughtSortingGameState();
}

class _ThoughtSortingGameState extends State<ThoughtSortingGame> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, int> _thoughtsFrequency = {};
  final Map<String, String> _oppositeWords = {};
  late GenerativeModel _model;
  late ChatSession _chatSession;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  Future<void> _initializeGemini() async {
    await dotenv.load(fileName: "assets/.env");
    String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception("API Key is missing!");
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
    _chatSession = _model.startChat(history: [
      Content.text(
          "Extract only impactful one or two-word phrases from these journal entries.")
    ]);
  }

  Future<List<String>> _fetchJournalEntries() async {
    User? user = _auth.currentUser;
    if (user == null) return [];

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('journals')
        .orderBy('date', descending: true)
        .limit(5)
        .get();

    List<String> journalEntries =
        snapshot.docs.map((doc) => doc['content'] as String).toList();
    return journalEntries;
  }

  Future<void> _fetchThoughts() async {
    setState(() => _isLoading = true);
    List<String> journals = await _fetchJournalEntries();
    if (journals.isEmpty) {
      setState(() {
        _isLoading = false;
        _thoughtsFrequency.clear();
        _oppositeWords.clear();
      });
      return;
    }

    try {
      String prompt = "Here are some journal reflections:\n\n" +
          journals.join("\n\n") +
          "\n\nExtract only impactful one or two-word phrases from these entries.";

      final response = await _chatSession.sendMessage(Content.text(prompt));
      String responseText = response.text ?? "No thoughts found.";
      List<String> thoughts = responseText
          .split(RegExp(r'[,"\n]'))
          .map(
              (e) => e.trim().replaceAll('*', '')) // Remove unwanted characters
          .where((e) => e.split(' ').length <= 2 && e.isNotEmpty)
          .map((e) => e.replaceAll(
              RegExp(r'[^a-zA-Z\s]'), '')) // Remove non-alphabetic characters
          .toList();

      if (mounted) {
        setState(() {
          _thoughtsFrequency.clear();
          _oppositeWords.clear();
          for (var thought in thoughts) {
            _thoughtsFrequency[thought] =
                (_thoughtsFrequency[thought] ?? 0) + 1;
          }
        });

        // Fetch opposite words
        for (var thought in thoughts) {
          await _fetchOppositeWord(thought);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _thoughtsFrequency.clear();
          _oppositeWords.clear();
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchOppositeWord(String word) async {
    try {
      final response = await _chatSession.sendMessage(Content.text(
        "Provide a single-word opposite for: $word",
      ));
      String oppositeWord = response.text?.trim() ?? "";
      if (mounted) {
        setState(() {
          _oppositeWords[word] = oppositeWord.split(' ').first;
        });
      }
    } catch (e) {
      print("⚠️ ERROR with Gemini: $e");
      if (mounted) {
        setState(() {
          _oppositeWords[word] = "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text("Mindful Thought Cloud",
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _thoughtsFrequency.isEmpty
                  ? Text("No thoughts generated yet.")
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ThoughtWordCloud(
                        thoughts: _thoughtsFrequency,
                        oppositeWords: _oppositeWords,
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _fetchThoughts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isLoading ? "Generating..." : "Generate Thoughts",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThoughtWordCloud extends StatelessWidget {
  final Map<String, int> thoughts;
  final Map<String, String> oppositeWords;

  ThoughtWordCloud({required this.thoughts, required this.oppositeWords});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: thoughts.entries.expand((entry) {
        double fontSize =
            14 + (entry.value * 3).toDouble(); // Adjust size based on frequency
        return [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: primaryColor, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              entry.key,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              oppositeWords[entry.key] ?? "",
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ];
      }).toList(),
    );
  }
}
