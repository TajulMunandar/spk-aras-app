import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spk_food_aras/component/bottom_nav_bar.dart'; // Import widget BottomNavBar
import 'package:spk_food_aras/service/auth.dart';
import 'package:spk_food_aras/service/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  int userId = 0;
  String name = '';
  String gender = '';
  int height = 0;
  int weight = 0;
  int cholesterol = 0;
  int age = 0;
  int serat = 0;
  int protein = 0;
  int lemak = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userProfileString = prefs.getString('user_profile');
      String? dataProfileString = prefs.getString('data');

      if (userProfileString != null && dataProfileString != null) {
        Map<String, dynamic> userProfile = jsonDecode(userProfileString);
        Map<String, dynamic> dataProfile = jsonDecode(dataProfileString);

        print("User Profile: $userProfile");
        print("Data Profile: $dataProfile");

        setState(() {
          userId = userProfile['id'] ?? 0; // Ensure ID is treated as int
          name = userProfile['name'] ?? '';
          gender = userProfile['jk'] ?? '';
          height = int.tryParse(dataProfile['tb'].toString()) ??
              0; // Ensure height is int
          weight = int.tryParse(dataProfile['bb'].toString()) ??
              0; // Ensure weight is int
          cholesterol = int.tryParse(dataProfile['kolesterol'].toString()) ??
              0; // Ensure cholesterol is int
          age = int.tryParse(dataProfile['umur'].toString()) ??
              0; // Ensure age is int
          serat = int.tryParse(dataProfile['serat'].toString()) ??
              0; // Ensure age is int
          lemak = int.tryParse(dataProfile['lemak'].toString()) ??
              0; // Ensure age is int
          protein = int.tryParse(dataProfile['protein'].toString()) ??
              0; // Ensure age is int
        });
      } else {
        print("User profile or data profile is null");
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  String classifyCholesterol() {
    if (cholesterol >= 200) {
      return 'Tinggi';
    } else {
      return 'Normal';
    }
  }

  Future<void> _updateUserData(Map<String, dynamic> updatedData) async {
    try {
      final String? accessToken = await ApiService.getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token found');
      }
      final url = Uri.parse(
          'https://cholesterol.sirehatcerdas.online/api/profile'); // Ganti dengan URL API Anda
      final response = await http.put(
        url,
        headers: {
          'Authorization':
              'Bearer $accessToken', // Ganti dengan token otentikasi jika diperlukan
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': userId,
          'name': updatedData['name'],
          'jk': updatedData['gender'],
          'tb': updatedData['height'].toString(),
          'bb': updatedData['weight'].toString(),
          'kolesterol': updatedData['cholesterol'].toString(),
          'umur': updatedData['age'],
          'serat': updatedData['serat'],
          'lemak': updatedData['lemak'],
          'protein': updatedData['protein'],
        }),
      );

      if (response.statusCode == 200) {
        print('Data updated successfully');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'user_profile',
            jsonEncode({
              'id': userId,
              'name': updatedData['name'],
              'jk': updatedData['gender'],
            }));
        await prefs.setString(
            'data',
            jsonEncode({
              'tb': updatedData['height'],
              'bb': updatedData['weight'],
              'kolesterol': updatedData['cholesterol'],
              'umur': updatedData['age'],
              'serat': updatedData['serat'],
              'lemak': updatedData['lemak'],
              'protein': updatedData['protein'],
            }));
        _loadUserData(); // Reload user data after update
      } else {
        print('Failed to update profile. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print("Error updating user data: $e");
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
                Icons.logout,
                size: 24.0,
                color: Colors.black,
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
              _buildInfoField('Cholesterol',
                  '(${classifyCholesterol()}) - ${cholesterol} mg/dL'),
              _buildInfoField('Age', '${age} years'),
              _buildInfoField('Lemak', '${lemak}'),
              _buildInfoField('Protein', '${protein}'),
              _buildInfoField('Serat', '${serat}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _showEditProfileForm(context);
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

  void _showEditProfileForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: EditProfileForm(
            name: name,
            gender: gender,
            height: height,
            weight: weight,
            cholesterol: cholesterol,
            age: age,
            serat: serat,
            protein: protein,
            lemak: lemak,
            onSave: (updatedData) async {
              await _updateUserData(updatedData);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}

class EditProfileForm extends StatefulWidget {
  final String name;
  final String gender;
  final int height;
  final int weight;
  final int cholesterol;
  final int age;
  final int serat;
  final int protein;
  final int lemak;
  final Function(Map<String, dynamic>) onSave;

  EditProfileForm({
    required this.name,
    required this.gender,
    required this.height,
    required this.weight,
    required this.cholesterol,
    required this.age,
    required this.serat,
    required this.protein,
    required this.lemak,
    required this.onSave,
  });

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _cholesterolController;
  late TextEditingController _ageController;
  late TextEditingController _seratController;
  late TextEditingController _proteinController;
  late TextEditingController _lemakController;
  String _selectedGender = 'Laki-laki';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _selectedGender = widget.gender;
    _heightController = TextEditingController(text: widget.height.toString());
    _weightController = TextEditingController(text: widget.weight.toString());
    _cholesterolController =
        TextEditingController(text: widget.cholesterol.toString());
    _ageController = TextEditingController(text: widget.age.toString());
    _seratController = TextEditingController(text: widget.serat.toString());
    _proteinController = TextEditingController(text: widget.protein.toString());
    _lemakController = TextEditingController(text: widget.lemak.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _cholesterolController.dispose();
    _ageController.dispose();
    _seratController.dispose();
    _proteinController.dispose();
    _lemakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Name', _nameController),
            _buildDropdownField('Gender', _selectedGender),
            _buildTextField('Height (cm)', _heightController, isNumeric: true),
            _buildTextField('Weight (kg)', _weightController, isNumeric: true),
            _buildTextField('Cholesterol (mg/dL)', _cholesterolController,
                isNumeric: true),
            _buildTextField('Age (years)', _ageController, isNumeric: true),
            _buildTextField('Lemak', _lemakController, isNumeric: true),
            _buildTextField('Protein', _proteinController, isNumeric: true),
            _buildTextField('Serat', _seratController, isNumeric: true),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedData = {
                    'name': _nameController.text,
                    'gender': _selectedGender,
                    'height': int.tryParse(_heightController.text) ?? 0,
                    'weight': int.tryParse(_weightController.text) ?? 0,
                    'cholesterol':
                        int.tryParse(_cholesterolController.text) ?? 0,
                    'age': int.tryParse(_ageController.text) ?? 0,
                    'lemak': int.tryParse(_lemakController.text) ?? 0,
                    'protein': int.tryParse(_proteinController.text) ?? 0,
                    'serat': int.tryParse(_seratController.text) ?? 0,
                  };
                  widget.onSave(updatedData);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumeric = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, String selectedValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: ['laki-laki', 'perempuan'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedGender = newValue!;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }
}
