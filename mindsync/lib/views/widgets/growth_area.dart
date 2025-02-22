import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindsync/data/colors.dart';

class GrowthArea extends StatefulWidget {
  const GrowthArea({super.key});

  @override
  State<GrowthArea> createState() => _GrowthAreaState();
}

class _GrowthAreaState extends State<GrowthArea> {
  bool showRadarChart = true;
  late GenerativeModel _model;
  late ChatSession _chatSession;
  List<double> _scores = List.filled(6, 50);

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _fetchAndAnalyzeJournals();
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
          "You are a mental health coach. When given a set of journal entries, "
          "analyze them and provide scores (0-100) for these 6 growth areas:\n\n"
          "- Mental Health\n"
          "- Stress Management\n"
          "- Growth Mindset\n"
          "- Relationships\n"
          "- Self Awareness\n"
          "- Personal Development\n\n"
          "Return scores in this exact format: `[Mental Health: 80, Stress Management: 65, Growth Mindset: 75, Relationships: 60, Self Awareness: 85, Personal Development: 70]`."),
    ]);
  }

  Future<void> _fetchAndAnalyzeJournals() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('journals')
        .orderBy('date', descending: true)
        .limit(5)
        .get();

    List<String> journals =
        snapshot.docs.map((doc) => doc['content'] as String).toList();
    if (journals.isEmpty) return;

    try {
      final response = await _chatSession.sendMessage(Content.text(
          "Here are journal reflections:\n\n" +
              journals.join("\n\n") +
              "\n\nAnalyze and provide scores as requested."));

      String botResponse = response.text ?? "";
      List<double> newScores = _parseScores(botResponse);

      setState(() {
        _scores = newScores;
      });
    } catch (e) {
      print("⚠️ Error analyzing journals: $e");
    }
  }

  List<double> _parseScores(String response) {
    final RegExp regExp = RegExp(r'(\d{1,3})');
    final matches = regExp.allMatches(response);
    List<double> extractedScores =
        matches.map((match) => double.parse(match.group(0)!)).toList();

    return extractedScores.length == 6
        ? extractedScores
        : List.filled(6, 50);
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
            SizedBox(height: 16),
            _buildScoresTable(),
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
            dataEntries:
                _scores.map((score) => RadarEntry(value: score)).toList(),
            borderColor: primaryColor,
            fillColor: primaryColor.withOpacity(0.3),
          ),
        ],
        radarShape: RadarShape.polygon,
        titlePositionPercentageOffset: 0.2,
        getTitle: (index, angle) {
          const titles = [
            '🧠',
            '😌',
            '🌱',
            '🤝',
            '🔍',
            '📈'
          ];
          return RadarChartTitle(
            text: titles[index],
            angle: angle,
          );
        },
        tickCount: 5, 
        ticksTextStyle: TextStyle(color: Colors.transparent), 
      )),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barGroups: List.generate(6, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: _scores[index],
                  color: primaryColor,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const titles = [
                    '🧠',
                    '😌',
                    '🌱',
                    '🤝',
                    '🔍',
                    '📈'
                  ];
                  return Text(titles[value.toInt()],
                      style: TextStyle(fontSize: 8)); 
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoresTable() {
    const titles = [
      '🧠 Mental Health',
      '😌 Stress Management',
      '🌱 Growth Mindset',
      '🤝 Relationships',
      '🔍 Self Awareness',
      '📈 Personal Development'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titles[index],
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500), 
              ),
              Text(
                _scores[index].toString(),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500),               ),
            ],
          ),
        );
      }),
    );
  }
}