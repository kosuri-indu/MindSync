import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindsync/data/colors.dart';

class ThoughtDetoxPage extends StatefulWidget {
  @override
  _ThoughtDetoxPageState createState() => _ThoughtDetoxPageState();
}

class _ThoughtDetoxPageState extends State<ThoughtDetoxPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String? _response;
  bool _isLoading = false;
  late GenerativeModel _model;
  late ChatSession _chatSession;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  Future<void> _initializeGemini() async {
    await dotenv.load(fileName: "assets/.env");
    String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    if (apiKey.isEmpty) {
      print("⚠️ ERROR: API Key is missing!");
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    _chatSession = _model.startChat(history: [
      Content.text(
        "You are an expert in cognitive reframing. When a user provides a negative thought, "
        "your task is to transform it into a **2-line positive perspective**. Keep it **uplifting, reassuring, and solution-focused**. "
        "Avoid analysis—just provide encouragement and a fresh way to see things.",
      )
    ]);
  }

  Future<void> _transformThought() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = null;
    });

    try {
      final response = await _chatSession.sendMessage(Content.text(
        "User's negative thought: ${_controller.text}\n\n"
        "Provide a 2-line positive perspective:",
      ));

      setState(() {
        _response =
            response.text ?? "You are resilient, and you can handle this.";
        _animationController.forward(from: 0);
      });
    } catch (e) {
      print("⚠️ ERROR with Gemini: $e");
      setState(() {
        _response = "Something went wrong. Try again.";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Thought Detox",
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your intrusive thought:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type here...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isLoading ? null : _transformThought,
                child: Text(_isLoading ? "Transforming..." : "Reframe Thought"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_response != null)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _response!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/fire.json', // ✅ Make sure this file is in `assets/`
                      width: 300,
                      repeat: true,
                    ),
                    SizedBox(height: 10),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Positioned(
                          top: _animation.value * 300,
                          child: Opacity(
                            opacity: 1 - _animation.value,
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        Icons.description,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
