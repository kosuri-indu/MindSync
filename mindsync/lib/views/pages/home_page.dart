import 'package:flutter/material.dart';
import 'package:mindsync/data/colors.dart';
import 'package:mindsync/views/pages/chatbot_page.dart';
import 'package:mindsync/views/pages/meditation_page.dart';
import 'package:mindsync/views/pages/breathing_page.dart';
import 'package:mindsync/views/pages/thought_detox.dart';
import 'package:mindsync/views/pages/voice_chat_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedFace = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Set the background color
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.spa, color: primaryColor),
                    Text('Home',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Icon(Icons.search),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Introduction to\nMental Health Issues',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Image.asset('assets/images/mental_health.png',
                          width: 100),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade200, blurRadius: 6)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('How do you feel today?',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (String face in [
                            'angry_face',
                            'sad_face',
                            'med_face',
                            'happy_face',
                            'laugh_face'
                          ])
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFace = face;
                                });
                              },
                              child: AnimatedScale(
                                scale: selectedFace == face ? 1.2 : 1.0,
                                duration: Duration(milliseconds: 300),
                                child: AnimatedOpacity(
                                  opacity: selectedFace == face ? 1.0 : 0.6,
                                  duration: Duration(milliseconds: 300),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: selectedFace == face
                                          ? primaryColor.withOpacity(0.2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.asset(
                                        'assets/images/$face.png',
                                        width: 50,
                                        height: 50),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Chat with Mindy Button
                    Expanded(
                      child: ActionButton(
                        text: 'Chat with Mindy',
                        icon: Icons.chat,
                        backgroundColor: Colors.white,
                        height: 60,
                        shadow: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatbotPage()),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10), // Space between buttons
                    // Voice Chat with Mindy Button
                    Expanded(
                      child: ActionButton(
                        text: 'Voice Chat with Mindy',
                        icon: Icons.mic,
                        backgroundColor: Colors.white,
                        height: 60,
                        shadow: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VoiceChatPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('Your plans for today (0/5)',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TaskCard(
                    title: 'Intro to Meditation',
                    category: 'Meditation',
                    duration: '8 mins',
                    image: 'meditation.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeditationPage(),
                        ),
                      );
                    }),
                TaskCard(
                    title: 'Thought Detox',
                    category: 'Articles',
                    duration: '2 mins read',
                    image: 'articles.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThoughtDetoxPage(),
                        ),
                      );
                    }),
                TaskCard(
                    title: 'Deep Breath Dynamics',
                    category: 'Breathing',
                    duration: '2-5 mins',
                    image: 'breathing.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BreathingPage(),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final double height;
  final bool shadow;
  final VoidCallback onPressed;

  ActionButton({
    required this.text,
    required this.icon,
    this.backgroundColor = Colors.grey,
    this.height = 50,
    this.shadow = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: height / 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: shadow
                ? [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 8),
              Text(text, style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String category;
  final String duration;
  final String image;
  final VoidCallback onTap;

  TaskCard({
    required this.title,
    required this.category,
    required this.duration,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category,
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold)),
                  Text(title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(duration, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Image.asset('assets/images/$image', width: 50, height: 50),
          ],
        ),
      ),
    );
  }
}
