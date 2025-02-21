import 'package:flutter/material.dart';
import 'package:mindsync/data/colors.dart';
import '../widgets/growth_area.dart';
import '../widgets/mood_tracker.dart';
import '../widgets/mood_calendar.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insights"),
        centerTitle: true,
        leading: Icon(Icons.spa, color: primaryColor),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const GrowthArea(),
            const SizedBox(height: 20),
            const MoodTracker(),
            const SizedBox(height: 20),
            const MoodCalendar(),
          ],
        ),
      ),
    );
  }
}
