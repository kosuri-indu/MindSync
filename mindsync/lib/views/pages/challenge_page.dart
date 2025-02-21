import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ComfortChallengePage extends StatefulWidget {
  @override
  _ComfortChallengePageState createState() => _ComfortChallengePageState();
}

class _ComfortChallengePageState extends State<ComfortChallengePage> {
  final List<String> _challenges = [];
  late GenerativeModel _model;
  late ChatSession _chatSession;

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
    try {
      final response = await _chatSession.sendMessage(Content.text(
          "Please provide 5 challenges to help someone step out of their comfort zone."));
      String challengesText = response.text ?? "No challenges available.";

      setState(() {
        _challenges.clear();
        _challenges.addAll(challengesText
            .split('\n')
            .where((challenge) => challenge.isNotEmpty));
      });
    } catch (e) {
      setState(() {
        _challenges.clear();
        _challenges.add("Failed to load challenges. Please try again.");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comfort Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _generateChallenges,
              child: Text('Generate Challenges'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _challenges.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_challenges[index]),
                    value: false,
                    onChanged: (bool? value) {},
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
