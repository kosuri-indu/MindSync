import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindsync/data/colors.dart'; // Ensure primaryColor is defined here

class ComfortChallengePage extends StatefulWidget {
  @override
  _ComfortChallengePageState createState() => _ComfortChallengePageState();
}

class _ComfortChallengePageState extends State<ComfortChallengePage> {
  final List<String> _challenges = [];
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
      safetySettings: [
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );

    _chatSession = _model.startChat(history: [
      Content.text(
        "You are a supportive and encouraging assistant. "
        "Your goal is to provide gentle challenges to help people step out of their comfort zones. "
        "Keep responses short and positive.",
      )
    ]);
  }

  Future<void> _generateChallenges() async {
    setState(() => _isLoading = true);

    try {
      final response = await _chatSession.sendMessage(Content.text(
          "Please provide 5 challenges to help someone step out of their comfort zone."));
      String challengesText = response.text ?? "No challenges available.";

      if (mounted) {
        setState(() {
          _challenges.clear();
          _challenges.addAll(challengesText
              .split('\n')
              .where((challenge) => challenge.trim().isNotEmpty));
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _challenges.clear();
          _challenges.add("Failed to load challenges. Please try again.");
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
          title: Text("Comfort Challenge",
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateChallenges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                    _isLoading ? "Generating..." : "Generate Challenges",
                    style: TextStyle(color: Colors.black)),
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: _challenges.length,
                itemBuilder: (context, index) {
                  bool isPrimaryColor = index % 2 == 0;
                  return Card(
                    color: isPrimaryColor ? primaryColor : Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        _challenges[index],
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
