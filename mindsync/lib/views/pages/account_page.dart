import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindsync/data/colors.dart';
import 'package:mindsync/views/pages/affirmations_page.dart';
import 'package:mindsync/views/pages/breathing_page.dart';
import 'package:mindsync/views/pages/challenge_page.dart';
import 'package:mindsync/views/pages/chatbot_page.dart';
import 'package:mindsync/views/pages/meditation_page.dart';
import 'package:mindsync/views/pages/quotes_page.dart';
import 'package:mindsync/views/pages/thought_detox.dart';
import 'package:mindsync/views/pages/voice_chat_page.dart';
import 'account_details_page.dart';
import 'package:mindsync/widget_tree.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userName = "";
  String userGoals = "";
  String profileImage = "https://via.placeholder.com/150";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc.get('name') ?? "User Name";
            userGoals = userDoc.get('goals') ?? "No goals found";
          });
        } else {
          print("No user document found.");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text("Account",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.spa, color: primaryColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildUpgradeBanner(),
              SizedBox(height: 16),
              _buildProfileSection(context),
              SizedBox(height: 16),
              _buildFeaturesList(context),
              SizedBox(height: 16),
              _buildSettingsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradeBanner() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome to Your Account!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                Text("“The best way to predict the future is to create it.”",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountDetailsPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
                radius: 30, backgroundImage: NetworkImage(profileImage)),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName.isEmpty ? "User Name" : userName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildListItem(Icons.mic, "AI Voice Chat", VoiceChatPage()),
          _buildListItem(Icons.chat, "Text Chat", ChatbotPage()),
          _buildListItem(Icons.spa, "Meditation", MeditationPage()),
          _buildListItem(
              Icons.self_improvement, "Breathing Exercises", BreathingPage()),
          _buildListItem(
              Icons.format_quote, "Daily Affirmations", AffirmationsPage()),
          _buildListItem(Icons.lightbulb, "Inspirational Quotes", QuotesPage()),
          _buildListItem(
              Icons.cleaning_services, "Thought Detox", ThoughtDetoxPage()),
          _buildListItem(Icons.emoji_events, "Comfort Zone Challenge",
              ComfortChallengePage()),
          _buildListItem(Icons.lock_clock, "Time Capsule", ThoughtDetoxPage()),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () async {
              await _auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => WidgetTree()), // Redirects properly
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
