import 'package:flutter/material.dart';
import 'package:mindsync/views/pages/home_page.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  String? gender;
  int? age;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tell us about yourself'),
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
                  (value) {
                setState(() {
                  gender = value;
                });
              }),
              const SizedBox(height: 20),
              _buildTextField('How old are you?', TextEditingController(),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              _buildMultiSelectField(
                  'What are your main goals?', goalsOptions, goals, (value) {
                setState(() {
                  goals = value;
                });
              }),
              const SizedBox(height: 20),
              _buildMultiSelectField('What causes your mental health issues?',
                  causesOptions, causes, (value) {
                setState(() {
                  causes = value;
                });
              }),
              const SizedBox(height: 20),
              _buildDropdownField(
                  'How often do you feel stressed or anxious in the last 12 months?',
                  stressFrequencyOptions, (value) {
                setState(() {
                  stressFrequency = value;
                });
              }),
              const SizedBox(height: 20),
              _buildDropdownField('Do you eat healthy?', healthyEatingOptions,
                  (value) {
                setState(() {
                  healthyEating = value;
                });
              }),
              const SizedBox(height: 20),
              _buildDropdownField('Have you tried meditation before?',
                  meditationExperienceOptions, (value) {
                setState(() {
                  meditationExperience = value;
                });
              }),
              const SizedBox(height: 20),
              _buildDropdownField(
                  'How would you rate your sleep quality overall?',
                  sleepQualityOptions, (value) {
                setState(() {
                  sleepQuality = value;
                });
              }),
              const SizedBox(height: 20),
              _buildDropdownField(
                  'How would you rate your level of happiness overall?',
                  happinessLevelOptions, (value) {
                setState(() {
                  happinessLevel = value;
                });
              }),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  },
                  child: Text('Submit'),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildMultiSelectField(String label, List<String> options,
      List<String> selectedValues, ValueChanged<List<String>> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: options.map((String option) {
            return FilterChip(
              label: Text(option),
              selected: selectedValues.contains(option),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedValues.add(option);
                  } else {
                    selectedValues.remove(option);
                  }
                  onChanged(selectedValues);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}