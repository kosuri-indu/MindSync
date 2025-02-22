import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindsync/views/pages/main_page.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? gender;
  List<String> goals = [];
  List<String> causes = [];
  String? stressFrequency;
  String? healthyEating;
  String? meditationExperience;
  String? sleepQuality;
  String? happinessLevel;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> stressFrequencyOptions = [
    'Almost daily',
    'A few times a week',
    'A few times a month',
    'Rarely',
    'Never'
  ];
  final List<String> healthyEatingOptions = [
    'Always',
    'Most of the time',
    'Sometimes',
    'Rarely',
    'Never'
  ];
  final List<String> meditationExperienceOptions = ['Yes', 'No'];
  final List<String> sleepQualityOptions = [
    'Very good',
    'Good',
    'Average',
    'Poor',
    'Very poor'
  ];
  final List<String> happinessLevelOptions = [
    'Very happy',
    'Happy',
    'Neutral',
    'Unhappy',
    'Very unhappy'
  ];
  final List<String> goalsOptions = [
    'Manage anxiety',
    'Reduce stress',
    'Improve mood',
    'Improve sleep',
    'Enhance relationships'
  ];
  final List<String> causesOptions = [
    'Work/school',
    'Relationships',
    'Finances',
    'Health',
    'Other'
  ];

  Future<void> _saveDataToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User not authenticated. Redirecting to login...");
      return;
    }

    String uid = user.uid;

    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'userId': uid, // Ensures Firestore security rule conditions are met
        'name': nameController.text,
        'age': int.tryParse(ageController.text) ?? 0,
        'gender': gender,
        'goals': goals,
        'causes': causes,
        'stressFrequency': stressFrequency,
        'healthyEating': healthyEating,
        'meditationExperience': meditationExperience,
        'sleepQuality': sleepQuality,
        'happinessLevel': happinessLevel,
      }, SetOptions(merge: true)); // Merge prevents overwriting existing fields

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tell us about yourself', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('What should we call you?', nameController),
              const SizedBox(height: 20),
              _buildDropdownField('What is your gender?', genderOptions,
                  (value) => setState(() => gender = value)),
              const SizedBox(height: 20),
              _buildTextField('How old are you?', ageController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              _buildMultiSelectField(
                  'What are your main goals?', goalsOptions, goals),
              const SizedBox(height: 20),
              _buildMultiSelectField('What causes your mental health issues?',
                  causesOptions, causes),
              const SizedBox(height: 20),
              _buildDropdownField(
                  'How often do you feel stressed?',
                  stressFrequencyOptions,
                  (value) => setState(() => stressFrequency = value)),
              const SizedBox(height: 20),
              _buildDropdownField('Do you eat healthy?', healthyEatingOptions,
                  (value) => setState(() => healthyEating = value)),
              const SizedBox(height: 20),
              _buildDropdownField(
                  'Have you tried meditation before?',
                  meditationExperienceOptions,
                  (value) => setState(() => meditationExperience = value)),
              const SizedBox(height: 20),
              _buildDropdownField(
                  'How would you rate your sleep quality?',
                  sleepQualityOptions,
                  (value) => setState(() => sleepQuality = value)),
              const SizedBox(height: 20),
              _buildDropdownField('How happy are you?', happinessLevelOptions,
                  (value) => setState(() => happinessLevel = value)),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveDataToFirestore,
                    child: Text('Submit'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) =>
          (value == null || value.isEmpty) ? '$label cannot be empty' : null,
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      items: options
          .map((String value) =>
              DropdownMenuItem<String>(value: value, child: Text(value)))
          .toList(),
      onChanged: onChanged,
      validator: (value) =>
          (value == null || value.isEmpty) ? '$label cannot be empty' : null,
    );
  }

  Widget _buildMultiSelectField(
      String label, List<String> options, List<String> selectedValues) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: options.map((String option) {
            return FilterChip(
              label: Text(option),
              selected: selectedValues.contains(option),
              onSelected: (bool selected) {
                setState(() {
                  selected
                      ? selectedValues.add(option)
                      : selectedValues.remove(option);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
