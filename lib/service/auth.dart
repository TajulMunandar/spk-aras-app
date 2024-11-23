import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<String?> authenticate(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://cholesterol.sirehatcerdas.online/api/login'),
      body: {
        'username': username,
        'password': password,
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final accessToken = jsonData['access_token'];
      final userProfile = jsonData['user_profile'];
      final data = jsonData['data'];

      await saveAccessToken(accessToken);
      await saveUserProfile(userProfile);
      await saveDataProfile(data);

      return accessToken;
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  static Future<void> saveUserProfile(Map<String, dynamic> userProfile) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile', json.encode(userProfile));
    } catch (e) {
      print('Failed to save user profile: $e');
      throw Exception('Failed to save user profile');
    }
  }

  static Future<void> saveDataProfile(Map<String, dynamic> userProfile) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('data', json.encode(userProfile));
    } catch (e) {
      print('Failed to save data Profile: $e');
      throw Exception('Failed to save data Profile');
    }
  }

  static Future<void> saveAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}
