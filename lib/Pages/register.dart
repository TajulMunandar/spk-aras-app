import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController tbController = TextEditingController();
  final TextEditingController bbController = TextEditingController();
  final TextEditingController kolesterolController = TextEditingController();
  final TextEditingController umurController = TextEditingController();
  String? _selectedGender;
  String? _selectedActivity;

  Future<void> _registerAndSubmitPatientData() async {
    int? aktivitasId;
    switch (_selectedActivity) {
      case 'ringan':
        aktivitasId = 1;
        break;
      case 'sedang':
        aktivitasId = 2;
        break;
      case 'berat':
        aktivitasId = 3;
        break;
      default:
        aktivitasId = null;
    }
    if (_formKey.currentState?.validate() ?? false) {
      final registerResponse = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/register'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'name': nameController.text,
          'username': usernameController.text,
          'password': passwordController.text,
          'role': 'user',
          'jk': _selectedGender,
          'aktivitas_id': aktivitasId,
          'tb': tbController.text,
          'bb': bbController.text,
          'kolesterol': kolesterolController.text,
          'umur': umurController.text,
        }),
      );

      if (registerResponse.statusCode == 201) {
        final responseJson = jsonDecode(registerResponse.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Registration and patient data submitted successfully')),
        );
        // Clear fields or navigate to another page
        _formKey.currentState?.reset();
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Registration failed: ${registerResponse.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5F1FA),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      child: Lottie.asset(
                        'assets/logo.json',
                        width: 250,
                        height: 250,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Register',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Register dan cari makanan dengan kebutuhan anda!',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                        color: Color(0xff636973)),
                  ),
                  // Registration Fields
                  _buildTextField(nameController, 'Name', Icons.verified_user),
                  _buildTextField(usernameController, 'Username',
                      Icons.supervised_user_circle),
                  _buildTextField(passwordController, 'Password', Icons.lock,
                      obscureText: true),
                  _buildDropdown<String>(
                    _selectedGender,
                    ['laki-laki', 'perempuan'],
                    'Jenis Kelamin',
                    Icons.male,
                    (String? newValue) =>
                        setState(() => _selectedGender = newValue),
                  ),
                  _buildDropdown<String>(
                    _selectedActivity,
                    ['ringan', 'sedang', 'berat'],
                    'Aktivitas',
                    Icons.accessibility_new,
                    (String? newValue) =>
                        setState(() => _selectedActivity = newValue),
                  ),
                  _buildTextField(tbController, 'Height (cm)', Icons.height,
                      keyboardType: TextInputType.number),
                  _buildTextField(
                      bbController, 'Weight (kg)', Icons.monitor_weight,
                      keyboardType: TextInputType.number),
                  _buildTextField(kolesterolController, 'Cholesterol Level',
                      Icons.health_and_safety,
                      keyboardType: TextInputType.number),
                  _buildTextField(umurController, 'Age', Icons.cake,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _registerAndSubmitPatientData,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xffffffff),
                      backgroundColor: Colors.yellow.shade600,
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Register',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: const Text('Sudah Punya Akun? Login!',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff636973))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xff9AA2AF)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.yellow.shade600)),
          hintText: label,
        ),
        validator: (value) =>
            value?.isEmpty ?? true ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDropdown<T>(T? value, List<T> items, String hint, IconData icon,
      ValueChanged<T?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString()),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xff9AA2AF)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.yellow.shade600)),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        isExpanded: true,
      ),
    );
  }
}
