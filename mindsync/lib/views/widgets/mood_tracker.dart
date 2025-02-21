import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mindsync/data/colors.dart';

class MoodTracker extends StatefulWidget {
  const MoodTracker({super.key});

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  bool showLineChart = true;

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
            showLineChart ? _buildLineChart() : _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return SizedBox(
      height: 150,
      child: LineChart(LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(1, 2),
              FlSpot(2, 4),
              FlSpot(3, 3),
              FlSpot(4, 5),
              FlSpot(5, 3),
              FlSpot(6, 4),
            ],
            isCurved: true,
            color: primaryColor,
            barWidth: 4,
            isStrokeCapRound: true,
          ),
        ],
      )),
    );
  }

  Widget _buildBarChart() {
    return const SizedBox(
      height: 150,
      child: Text("Bar Chart Placeholder"),
    );
  }
}
