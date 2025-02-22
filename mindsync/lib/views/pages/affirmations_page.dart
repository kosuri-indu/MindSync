import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindsync/data/colors.dart'; 

class AffirmationsPage extends StatefulWidget {
  @override
  _AffirmationsPageState createState() => _AffirmationsPageState();
}

class _AffirmationsPageState extends State<AffirmationsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late GenerativeModel _model;
  late ChatSession _chatSession;
  List<String> _affirmations = [];
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
      safetySettings: [
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );

    _chatSession = _model.startChat(history: [
      Content.text(
        "You are a compassionate mental health coach. Your task is to generate 10 short, uplifting quotes based on a user's recent journal entries. "
        "Keep them positive, encouraging, and warm. Do not analyze, just provide encouragement.",
      )
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
    print("Fetched journal entries: $journalEntries");
    return journalEntries;
  }

  Future<void> _generateAffirmations() async {
    setState(() => _isLoading = true);

    List<String> journals = await _fetchJournalEntries();
    if (journals.isEmpty) {
      setState(() {
        _isLoading = false;
        _affirmations = [
          "No journal entries found. Start writing to get quotes!"
        ];
      });
      return;
    }

    try {
      String prompt = "Here are some journal reflections:\n\n" +
          journals.join("\n\n") +
          "\n\nBased on this, provide 10 quotes without numbers.";
      print("Sending prompt to Gemini: $prompt");

      final response = await _chatSession.sendMessage(Content.text(prompt));

      String botResponse =
          response.text ?? "You are strong, and you are not alone.";
      print("Received response from Gemini: $botResponse");

      setState(() {
        _affirmations =
            botResponse.split("\n").where((a) => a.trim().isNotEmpty).toList();
      });
    } catch (e) {
      print("Error generating affirmations: $e");
      setState(() {
        _affirmations = ["Something went wrong. Try again later."];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(title: Text("Your Daily Affirmations")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateAffirmations,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(_isLoading ? "Generating..." : "Get Affirmations",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: _affirmations.length,
                itemBuilder: (context, index) {
                  bool isPrimaryColor = index % 2 == 0;
                  return Card(
                    color: isPrimaryColor ? primaryColor : Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        _affirmations[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: isPrimaryColor ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
