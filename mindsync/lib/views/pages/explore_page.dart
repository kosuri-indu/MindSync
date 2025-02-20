import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(234, 237, 237, 255),
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFD5DBDB), // Background color
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Meditation Button
            exploreButton(
              image: Image.asset('assets/images/meditation.png'),
              text: "Meditation",
              color: Colors.white,
              onPressed: () {
                // Navigate to Meditation Page
              },
            ),

            // Breathing Button
            exploreButton(
              image: Image.asset('assets/images/breathing.png'),
              text: "Breathing",
              color: Colors.white,
              onPressed: () {
                // Navigate to Breathing Page
              },
            ),

            // Articles Button
            exploreButton(
              image: Image.asset('assets/images/articles.png'),
              text: "Articles",
              color: Colors.white,
              onPressed: () {
                // Navigate to Articles Page
              },
            ),

            // Affirmations Button
            exploreButton(
              image: Image.asset('assets/images/affirmations.png'),
              text: "Affirmations",
              color: Colors.white,
              onPressed: () {
                // Navigate to Affirmations Page
              },
            ),

            // Quotes Button
            exploreButton(
              image: Image.asset('assets/images/quotes.png'),
              text: "Quotes",
              color: Colors.white,
              onPressed: () {
                // Navigate to Quotes Page
              },
            ),

            // Smart Journal Button
            exploreButton(
              image: Image.asset('assets/images/journal.png'),
              text: "Smart Journal",
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, '/journal');
              },
            ),
          ],
        ),
      ),
    );
  }

  // Explore Button Widget
  Widget exploreButton({
    required Image image,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
