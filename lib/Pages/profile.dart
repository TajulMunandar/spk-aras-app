import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spk_food_aras/component/bottom_nav_bar.dart'; // Import widget BottomNavBar
import 'package:spk_food_aras/service/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavBar(
      child: ProfilePageContent(),
    );
  }
}

class ProfilePageContent extends StatefulWidget {
  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  String name = '';
  String gender = '';
  int height = 0;
  int weight = 0;
  int cholesterol = 0;
  int age = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userProfileString = prefs.getString('user_profile');
    String? dataProfileString = prefs.getString('data');

    if (userProfileString != null && dataProfileString != null) {
      Map<String, dynamic> userProfile = jsonDecode(userProfileString);
      Map<String, dynamic> dataProfile = jsonDecode(dataProfileString);

      setState(() {
        name = userProfile['name'] ?? '';
        gender = userProfile['jk'] ?? ''; // 'jk' from user_profile
        height = dataProfile['tb'] ?? 0; // 'tb' from data
        weight = dataProfile['bb'] ?? 0; // 'bb' from data
        cholesterol = dataProfile['kolesterol'] ?? 0; // 'kolesterol' from data
        age = dataProfile['umur'] ?? 0; // 'umur' from data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade400,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Logout.performLogout(context);
              },
              child: const Icon(
                Icons.logout, // Use the logout icon
                size: 24.0, // Adjust the size of the icon
                color: Colors.black, // Adjust the color of the icon
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'A',
                    style: TextStyle(fontSize: 40, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildInfoField('Name', name),
              _buildInfoField('Gender', gender),
              _buildInfoField('Height', '${height} cm'),
              _buildInfoField('Weight', '${weight} kg'),
              _buildInfoField('Cholesterol', '${cholesterol} mg/dL'),
              _buildInfoField('Age', '${age} years'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to edit profile page or perform another action
                },
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
