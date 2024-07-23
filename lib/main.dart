import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spk_food_aras/Pages/home.dart';
import 'package:spk_food_aras/Pages/register.dart';
import 'package:spk_food_aras/Pages/search.dart';
import 'package:spk_food_aras/Pages/splash.dart';
import 'package:spk_food_aras/Pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      title: 'Rekomendasi Makanan',
      home: SplashScreen(),
      routes: {
        '/login': (context) => Login(),
        '/registration': (context) => Register(),
        '/home': (context) => HomePage(),
        '/search': (context) => SearchPage(),
      }, // Gunakan SplashScreen sebagai halaman utama
    );
  }
}
