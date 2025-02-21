import 'package:flutter/material.dart';
import 'package:mindsync/data/colors.dart';
import 'package:mindsync/views/pages/affirmations_page.dart';
import 'meditation_page.dart';
import 'breathing_page.dart';
import 'journal_page.dart';

class ExplorePage extends StatelessWidget {
  final List<Map<String, String>> exploreItems = [
    {'title': 'Meditations', 'icon': 'assets/images/meditation.png'},
    {'title': 'Breathing', 'icon': 'assets/images/breathing.png'},
    {'title': 'Articles', 'icon': 'assets/images/articles.png'},
    {'title': 'Smart Jour...', 'icon': 'assets/images/journal.png'},
    {'title': 'Affirmations', 'icon': 'assets/images/affirmations.png'},
    {'title': 'Quotes', 'icon': 'assets/images/quotes.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.spa, color: primaryColor),
        actions: [
          IconButton(
              icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Explore",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              SizedBox(
                height: 400, // Adjust the height as needed
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: exploreItems.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (exploreItems[index]['title'] == 'Meditations') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MeditationPage()),
                          );
                        } else if (exploreItems[index]['title'] ==
                            'Breathing') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BreathingPage()),
                          );
                        } else if (exploreItems[index]['title'] ==
                            'Smart Jour...') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JournalPage()),
                          );
                        } else if (exploreItems[index]['title'] ==
                            'Affirmations') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AffirmationsPage()),
                          );
                        }
                        // Add more conditions for other pages if needed
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(exploreItems[index]['icon']!,
                                height: 50),
                            SizedBox(height: 8),
                            Text(
                              exploreItems[index]['title']!,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
