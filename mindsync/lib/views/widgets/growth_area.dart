import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GrowthArea extends StatefulWidget {
  const GrowthArea({super.key});

  @override
  State<GrowthArea> createState() => _GrowthAreaState();
}

class _GrowthAreaState extends State<GrowthArea> {
  bool showRadarChart = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Growth Area",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(showRadarChart ? Icons.bar_chart : Icons.radar),
                  onPressed: () {
                    setState(() {
                      showRadarChart = !showRadarChart;
                    });
                  },
                ),
              ],
            ),
            showRadarChart ? _buildRadarChart() : _buildBarChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildRadarChart() {
    return SizedBox(
      height: 200,
      child: RadarChart(RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              RadarEntry(value: 76),
              RadarEntry(value: 55),
              RadarEntry(value: 73),
              RadarEntry(value: 68),
              RadarEntry(value: 72),
              RadarEntry(value: 54),
            ],
            borderColor: Colors.green,
            fillColor: Colors.green.withOpacity(0.3),
          ),
        ],
        radarShape: RadarShape.polygon,
        titlePositionPercentageOffset: 0.2,
        getTitle: (index, angle) {
          switch (index) {
            case 0:
              return RadarChartTitle(
                text: 'Mental Health',
                angle: angle,
              );
            case 1:
              return RadarChartTitle(
                text: 'Stress Management',
                angle: angle,
              );
            case 2:
              return RadarChartTitle(
                text: 'Growth Mindset',
                angle: angle,
              );
            case 3:
              return RadarChartTitle(
                text: 'Relationships',
                angle: angle,
              );
            case 4:
              return RadarChartTitle(
                text: 'Self Awareness',
                angle: angle,
              );
            case 5:
              return RadarChartTitle(
                text: 'Personal Development',
                angle: angle,
              );
            default:
              return RadarChartTitle(text: '', angle: angle);
          }
        },
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
