import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  _BreathingPageState createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage> {
  bool showAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Set the background color
      appBar: AppBar(
        title: const Text(
          'Breathing Exercise',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
                Text(
                  'Relax and follow the animation to breathe in and out',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                showAnimation
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            showAnimation = false;
                          });
                        },
                        child: Lottie.asset('assets/lottie/breath.json'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showAnimation = true;
                          });
                        },
                        child: const Text(
                          'Press to start',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFF9EB567), // Use primary color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
