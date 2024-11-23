import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spk_food_aras/component/bottom_nav_bar.dart'; // Import widget BottomNavBar
import 'package:spk_food_aras/service/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavBar(
      child: SearchPageContent(),
    );
  }
}

class SearchPageContent extends StatefulWidget {
  @override
  _SearchPageContentState createState() => _SearchPageContentState();
}

class _SearchPageContentState extends State<SearchPageContent> {
  String name = '';
  int tb = 0;
  int bb = 0;
  int kolesterol = 0;
  int umur = 0;
  int serat = 0;
  int protein = 0;
  int lemak = 0;
  List<dynamic> foodData = [];
  List<Map<dynamic, dynamic>> recommendations = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchFoodData();
  }

  Future<void> fetchFoodData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userProfile = prefs.getString('user_profile');

    if (userProfile != null) {
      final userData = json.decode(userProfile);
      final userId = userData['id'];

      print('User ID: $userId');

      final response = await http.post(
        Uri.parse('https://cholesterol.sirehatcerdas.online/api/aras'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id': userId,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          foodData = data['data']; // Sesuaikan dengan struktur data API
          recommendations = foodData.map<Map<dynamic, dynamic>>((item) {
            return {
              'name': item['alternatif']['nama'],
              'recommendation': 'Score: ${item['value']}',
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load registration data');
      }
    } else {
      throw Exception('User profile not found in SharedPreferences');
    }
  }

  String classifyCholesterol() {
    if (kolesterol >= 200) {
      return 'Tinggi';
    } else {
      return 'Normal';
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userProfileString = prefs.getString('user_profile');
    String? dataString = prefs.getString('data');

    print("Retrieved user_profile: $userProfileString");
    print("Retrieved data: $dataString");

    if (userProfileString != null && dataString != null) {
      Map<String, dynamic> userProfile = jsonDecode(userProfileString);
      Map<String, dynamic> data = jsonDecode(dataString);

      print("Decoded User Profile: $userProfile");
      print("Decoded Data: $data");

      // Use a temporary map to store the data with type conversion
      Map<String, dynamic> tempData = {
        'name': userProfile['name'] ?? '',
        'tb': int.tryParse(data['tb'].toString()) ?? 0,
        'bb': int.tryParse(data['bb'].toString()) ?? 0,
        'kolesterol': int.tryParse(data['kolesterol'].toString()) ?? 0,
        'umur': int.tryParse(data['umur'].toString()) ?? 0,
        'serat': int.tryParse(data['serat'].toString()) ?? 0,
        'protein': int.tryParse(data['protein'].toString()) ?? 0,
        'lemak': int.tryParse(data['lemak'].toString()) ?? 0,
      };

      // Use setState only after processing the data
      setState(() {
        name = tempData['name'];
        tb = tempData['tb'];
        bb = tempData['bb'];
        kolesterol = tempData['kolesterol'];
        umur = tempData['umur'];
        serat = tempData['serat'];
        lemak = tempData['lemak'];
        protein = tempData['protein'];
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
              'Food Recommendation',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade400.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.yellow.shade800,
                                      child: Text(
                                        name.isNotEmpty
                                            ? name[0].toUpperCase()
                                            : 'A',
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        '$name',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tinggi Badan: $tb cm',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      'Berat Badan: $bb kg',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Kolesterol: $kolesterol / (${classifyCholesterol()})',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      'Umur: $umur tahun',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Protein: $protein ',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      'Lemak: $lemak',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Serat: $serat ',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Rekomendasi Makanan Sehatmu!',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 14),
                    Expanded(
                      child: ListView.builder(
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          final item = recommendations[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage('assets/bg.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        item['name'] ?? '',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow.shade800),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        item['recommendation'] ?? '',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
