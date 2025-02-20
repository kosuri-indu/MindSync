import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindsync/auth.dart';
import '../../data/colors.dart'; // Ensure this import is correct

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Home');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
      body: Container(
        color: backgroundColor, // Set background color
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MindSync Banner
            Container(
              decoration: BoxDecoration(
                color: primaryColor, // Set primary color
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "MindSync",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Roboto', // Apply a nice font
                      ),
                    ),
                  ),
                  Image.asset('assets/images/mental_health.png', height: 150),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Mood Tracker Box
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set white background
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "How do you feel today?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      moodImageButton(
                          Image.asset('assets/images/angry_face.png'),
                          Colors.red),
                      moodImageButton(Image.asset('assets/images/sad_face.png'),
                          Colors.orange),
                      moodImageButton(Image.asset('assets/images/med_face.png'),
                          Colors.grey),
                      moodImageButton(
                          Image.asset('assets/images/happy_face.png'),
                          Colors.lightGreen),
                      moodImageButton(
                          Image.asset('assets/images/laugh_face.png'),
                          Colors.green),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Chatbot and Smart Journal Buttons
            Column(
              children: [
                chatButton(Icons.chat_bubble_outline, "Chat with AI Companion",
                    Colors.white, context, '/chat'),
                const SizedBox(height: 10),
                chatButton(Icons.book, "Smart Journal", Colors.white, context,
                    '/journal'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Mood Image Button Widget
  Widget moodImageButton(Image imagePath, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor:
            color.withOpacity(0.8), // More saturated background color
        padding: const EdgeInsets.all(10), // Reduced size
      ),
      child: SizedBox(
        height: 40, // Reduced size
        width: 40, // Reduced size
        child: imagePath,
      ),
    );
  }

  // Chatbot Button Widget
  Widget chatButton(IconData icon, String text, Color color,
      BuildContext context, String route) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Set background color
          padding: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: primaryColor), // Set icon color
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor), // Set text color
            ),
          ],
        ),
      ),
    );
  }
}
