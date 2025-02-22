import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountDetailsPage extends StatefulWidget {
  @override
  _AccountDetailsPageState createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      if (user != null) {
        print("Fetching data for user ID: ${user!.uid}");
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (doc.exists) {
          print("User data found: ${doc.data()}");
          setState(() {
            userData = doc.data() as Map<String, dynamic>?;
            isLoading = false;
          });
        } else {
          print("User data not found for user ID: ${user!.uid}");
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User data not found')),
          );
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data')),
      );
    }
  }

  Future<void> _updateUserData(String field, String value) async {
    try {
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({field: value});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        _fetchUserData(); // Refresh data
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Details', style: TextStyle(fontWeight: FontWeight.bold),)),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(child: Text('No user data found'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailTile("Name", userData!['name'], 'name'),
                      _buildDetailTile(
                          "Age", userData!['age'].toString(), 'age'),
                      _buildDetailTile("Gender", userData!['gender'], 'gender'),
                      _buildDetailTile(
                          "Goals", userData!['goals'].join(', '), 'goals'),
                      _buildDetailTile(
                          "Causes", userData!['causes'].join(', '), 'causes'),
                      _buildDetailTile("Stress Frequency",
                          userData!['stressFrequency'], 'stressFrequency'),
                      _buildDetailTile("Healthy Eating",
                          userData!['healthyEating'], 'healthyEating'),
                      _buildDetailTile(
                          "Meditation Experience",
                          userData!['meditationExperience'],
                          'meditationExperience'),
                      _buildDetailTile("Sleep Quality",
                          userData!['sleepQuality'], 'sleepQuality'),
                      _buildDetailTile("Happiness Level",
                          userData!['happinessLevel'], 'happinessLevel'),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailTile(String title, String value, String field) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: TextStyle(color: Colors.grey)),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            _showEditDialog(title, value, field);
          },
        ),
      ),
    );
  }

  void _showEditDialog(String title, String currentValue, String field) {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: title),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateUserData(field, controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
