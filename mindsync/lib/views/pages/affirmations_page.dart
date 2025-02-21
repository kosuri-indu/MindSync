import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AffirmationsPage extends StatefulWidget {
  @override
  _AffirmationsPageState createState() => _AffirmationsPageState();
}

class _AffirmationsPageState extends State<AffirmationsPage> {
  String _affirmations = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchAndGenerateAffirmations();
  }

  Future<void> _fetchAndGenerateAffirmations() async {
    try {
      await dotenv.load();
      String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

      if (apiKey.isEmpty) {
        throw Exception("API Key is missing!");
      }

      print("Loaded API Key: $apiKey"); // Debugging line

      // Fetch journal data (Replace with actual fetching logic)
      String journalData = await _fetchJournalData();

      // Generate affirmations using Gemini Flash 1
      String affirmations = await _generateAffirmations(apiKey, journalData);

      setState(() {
        _affirmations = affirmations;
      });
    } catch (e) {
      setState(() {
        _affirmations = "Failed to load affirmations: ${e.toString()}";
      });
    }
  }

  Future<String> _fetchJournalData() async {
    // Replace with actual logic to fetch journal entries
    return "I had a stressful day but I managed to stay positive.";
  }

  Future<String> _generateAffirmations(
      String apiKey, String journalData) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateText?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "prompt":
            "Generate three short, positive affirmations based on this journal entry:\n$journalData",
        "max_tokens": 60
      }),
    );

    print("API Response: ${response.body}"); // Debugging line

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'] ??
          "No affirmations generated.";
    } else {
      throw Exception('Failed to generate affirmations: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Affirmations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_affirmations, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
