import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});

  @override
  _MeditationPageState createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  bool showAnimation = false;
  int selectedDuration = 2;
  Timer? _timer;
  int _remainingTime = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _startTimer() {
    setState(() {
      _remainingTime = selectedDuration * 60;
      showAnimation = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _audioPlayer.play(AssetSource('assets/sounds/completion_sound.mp3'));
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Meditation Complete'),
              content: Text(
                  'Great job! You have completed your meditation session.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      showAnimation = false;
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      showAnimation = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Set the background color
      appBar: AppBar(
        title: const Text('Meditation'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade200, blurRadius: 6)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!showAnimation) ...[
                  DropdownButton<int>(
                    value: selectedDuration,
                    items: [2, 5, 10, 15]
                        .map((duration) => DropdownMenuItem<int>(
                              value: duration,
                              child: Text('$duration minutes'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDuration = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, // Full width
                    child: ElevatedButton(
                      onPressed: _startTimer,
                      child: const Text('Start'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9EB567), // Use primary color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Lottie.asset('assets/lottie/breath.json'),
                  const SizedBox(height: 20),
                  Text(
                    'Time remaining: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, // Full width
                    child: ElevatedButton(
                      onPressed: _stopTimer,
                      child: const Text('Stop'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9EB567), // Use primary color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
