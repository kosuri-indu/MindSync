import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceChatPage extends StatefulWidget {
  @override
  _VoiceChatPageState createState() => _VoiceChatPageState();
}

class _VoiceChatPageState extends State<VoiceChatPage> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _text = "Press the mic and start speaking...";
  String _response = "Mindy's response will appear here...";
  late GenerativeModel _model;
  late ChatSession _chatSession;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeTTS();
    _initializeGemini();
  }

  void _initializeSpeech() async {
    try {
      _speech = stt.SpeechToText();
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Status: $status');
          if (status == "notListening") {
            setState(() => _isListening = false);
            _getResponse(_text);
          }
        },
        onError: (error) {
          print('Error: $error');
          setState(() => _isListening = false); 
        },
      );

      if (!available) {
        print("Speech recognition is not available.");
      }
    } catch (e) {
      print("Error initializing speech: $e");
    }
  }

  void _initializeTTS() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setPitch(1.0);
  }

  Future<void> _initializeGemini() async {
    await dotenv.load(fileName: "assets/.env");
    String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    print("API Key: $apiKey"); 

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
        "You are Mindy, a kind and empathetic mental wellness assistant. "
        "Your goal is to provide gentle, non-judgmental support and encouragement. "
        "Keep responses brief, natural, comforting, and easy to understand when spoken aloud. "
        "Avoid long paragraphs—respond in a conversational tone, just like a friendly chat. "
        "If someone expresses distress, offer comfort and suggest seeking professional help if needed. "
        "Always use a warm and caring voice.",
      )
    ]);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Status: $status');
          if (status == "notListening") {
            setState(() => _isListening = false);
            _getResponse(_text);
          }
        },
        onError: (error) {
          print('Error: $error');
          setState(() => _isListening = false);
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            print("Recognized words: ${result.recognizedWords}"); 
            setState(() {
              _text = result.recognizedWords;
            });
          },
          onSoundLevelChange: (level) {
            print("Sound level: $level"); 
          },
        );
      } else {
        print("Speech recognition not available.");
      }
    } else {
      _speech.stop(); 
      setState(() => _isListening = false); 
    }
  }

  Future<void> _getResponse(String query) async {
    if (query.isEmpty) return;

    try {
      final response = await _chatSession.sendMessage(Content.text(query));
      String botMessage =
          response.text ?? "I'm here to support you. You're not alone.";

      setState(() {
        _response = botMessage;
      });

      _speak(botMessage); 
    } catch (e) {
      print("Error: $e");
      _speak("I'm here for you. Let's take a deep breath together.");
    }
  }

  Future<void> _speak(String text) async {
    print("Speaking: $text"); 
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.1); 
    await _flutterTts.setSpeechRate(0.5); 
    await _flutterTts.setVolume(1.0); 

    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Voice Chat with Mindy")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You: $_text",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Mindy: $_response",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _listen,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: _isListening ? Colors.red : Colors.blue,
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
