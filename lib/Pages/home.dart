import 'package:flutter/material.dart';
import 'package:spk_food_aras/component/bottom_nav_bar.dart'; // Import widget BottomNavBar
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:spk_food_aras/component/card_food.dart';
import 'package:spk_food_aras/model/food.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spk_food_aras/service/logout.dart';

void main() => runApp(MaterialApp(home: HomePage()));

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavBar(
      child: HomePageContent(),
    );
  }
}

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String formattedTime = DateFormat.Hm().format(DateTime.now());
  int selectedService = 0;
  late Future<List<FoodModel>> _futureFoods;

  @override
  void initState() {
    super.initState();
    _futureFoods = fetchFoods(); // Inisialisasi Future untuk data makanan
  }

  Future<String?> _loadUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userProfile = prefs.getString('user_profile');
    if (userProfile != null) {
      final userData = json.decode(userProfile);
      return userData['username'];
    }
    return null;
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
                  // Implement your logout functionality here
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
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<String?>(
                  future: _loadUserProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final userName = snapshot.data ?? 'Guest';
                      return _greetings(userName);
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                _card(context),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Daftar Menu Makanan",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3F3E3F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<FoodModel>>(
                  future: _futureFoods,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final food = snapshot.data![index];
                          return CardFood(
                            model: food,
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Widget _greetings(String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Halo, $userName!",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3F3E3F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context) {
    return AspectRatio(
      aspectRatio: 336 / 184,
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.yellow.shade200,
        ),
        child: Stack(children: [
          Positioned(
            left: MediaQuery.of(context).size.width *
                0.3, // Mengatur posisi relatif ke kanan
            child: Container(
              width: 200, // Lebar sesuai kebutuhan
              height: 200, // Tinggi sesuai kebutuhan
              child: Lottie.asset(
                'assets/beranda.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Periksakan Kesehatan ",
                        style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: Colors.black,
                            height: 150 / 100),
                        children: [
                      TextSpan(
                          text: "\nKeluarga Anda! ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                    ])),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.1),
                      border: Border.all(
                          color: Colors.black.withOpacity(.12), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "$formattedTime WIB",
                    style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
