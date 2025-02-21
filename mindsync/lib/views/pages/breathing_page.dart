// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class BreathingPage extends StatefulWidget {
//   const BreathingPage({super.key});

//   @override
//   _BreathingPageState createState() => _BreathingPageState();
// }

// class _BreathingPageState extends State<BreathingPage> {
//   bool showAnimation = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Breathing Exercise'),
//         backgroundColor: const Color.fromARGB(234, 237, 237, 255),
//       ),
//       body: Center(
//         child: showAnimation
//             ? GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     showAnimation = false;
//                   });
//                 },
//                 child: Lottie.asset('assets/lottie/breath.json'),
//               )
//             : ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     showAnimation = true;
//                   });
//                 },
//                 child: const Text('Press to start'),
//               ),
//       ),
//     );
//   }
// }