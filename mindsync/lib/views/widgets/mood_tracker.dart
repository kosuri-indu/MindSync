import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:mindsync/data/colors.dart';

class MoodTracker extends StatefulWidget {
  const MoodTracker({super.key});

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  bool showLineChart = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch mood data from Firestore
  Future<Map<String, dynamic>> _fetchMoodData() async {
    User? user = _auth.currentUser;
    if (user == null) return {"spots": [], "dates": []};

    // Mapping mood image paths to numeric values
    Map<String, int> moodMapping = {
      "assets/images/angry_face.png": 1,
      "assets/images/sad_face.png": 2,
      "assets/images/med_face.png": 3,
      "assets/images/happy_face.png": 4,
      "assets/images/laugh_face.png": 5,
    };

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('journals')
          .orderBy('date', descending: false) // Sort by date
          .get();

      print("Fetched ${snapshot.docs.length} mood entries.");

      Map<String, int> latestMoods = {}; // Stores latest mood for each date

      for (var doc in snapshot.docs) {
        String dateString = doc['date']; // Example: "Feb 21, 2025"

        try {
          // Convert "Feb 21, 2025" to "YYYY-MM-DD"
          DateTime parsedDate = DateFormat("MMM dd, yyyy").parse(dateString);
          String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);

          String moodImagePath = doc['mood']; // Retrieve mood image path

          if (moodMapping.containsKey(moodImagePath)) {
            latestMoods[formattedDate] =
                moodMapping[moodImagePath]!; // Update latest mood for date
          }
        } catch (e) {
          print("Date parsing error: $e");
        }
      }

      List<FlSpot> moodPoints = [];
      List<String> sortedDates = latestMoods.keys.toList()
        ..sort(); // Sort dates
      for (int i = 0; i < sortedDates.length; i++) {
        moodPoints
            .add(FlSpot(i.toDouble(), latestMoods[sortedDates[i]]!.toDouble()));
      }

      return {"spots": moodPoints, "dates": sortedDates};
    } catch (e) {
      print("Error fetching mood data: $e");
      return {"spots": [], "dates": []};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mood Tracker",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon:
                      Icon(showLineChart ? Icons.bar_chart : Icons.show_chart),
                  onPressed: () {
                    setState(() {
                      showLineChart = !showLineChart;
                    });
                  },
                ),
              ],
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: _fetchMoodData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text("Error fetching mood data.");
                } else if (!snapshot.hasData ||
                    snapshot.data!['spots'].isEmpty) {
                  return const Text("No mood data available.");
                } else {
                  List<FlSpot> moodData = snapshot.data!['spots'];
                  List<String> dates = snapshot.data!['dates'];

                  return showLineChart
                      ? _buildLineChart(moodData, dates)
                      : _buildBarChart(moodData, dates);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build line chart for mood tracking
  Widget _buildLineChart(List<FlSpot> moodData, List<String> dates) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval:
                    dates.length > 5 ? (dates.length / 5).floorToDouble() : 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < dates.length) {
                    try {
                      DateTime parsedDate =
                          DateFormat("yyyy-MM-dd").parse(dates[index]);
                      return Text(DateFormat('MM/dd').format(parsedDate));
                    } catch (e) {
                      print("Chart date parsing error: $e");
                      return const Text('');
                    }
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: moodData,
              isCurved: true,
              color: primaryColor,
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  /// Build bar chart for mood tracking
  Widget _buildBarChart(List<FlSpot> moodData, List<String> dates) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: moodData
              .map((spot) => BarChartGroupData(
                    x: spot.x.toInt(),
                    barRods: [
                      BarChartRodData(
                          toY: spot.y, color: primaryColor, width: 10)
                    ],
                  ))
              .toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval:
                    dates.length > 5 ? (dates.length / 5).floorToDouble() : 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < dates.length) {
                    try {
                      DateTime parsedDate =
                          DateFormat("yyyy-MM-dd").parse(dates[index]);
                      return Text(DateFormat('MM/dd').format(parsedDate));
                    } catch (e) {
                      print("Chart date parsing error: $e");
                      return const Text('');
                    }
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
