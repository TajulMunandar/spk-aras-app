// card_food.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spk_food_aras/model/food.dart';

class CardFood extends StatelessWidget {
  final FoodModel model;

  CardFood({required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Card(
        color: Colors.yellow.shade200,
        child: ListTile(
          title: Text(
            model.alternatifNama,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Wrap(
            spacing: 6.0, // Add spacing between children
            runSpacing: 4.0, // Add vertical spacing between rows
            children: model.kriteria.map((kriteria) {
              return Padding(
                padding: const EdgeInsets.only(right: 6.0), // Add margin right
                child: Text(
                  '${kriteria.kriteriaNama}: ${kriteria.nilai}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          ),
          leading: Icon(
            Icons.food_bank,
            color: Colors.yellow.shade800,
          ),
        ),
      ),
    );
  }
}
