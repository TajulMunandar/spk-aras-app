import 'dart:convert';
import 'package:http/http.dart' as http;

class Kriteria {
  String kriteriaNama;
  dynamic nilai;

  Kriteria({
    required this.kriteriaNama,
    required this.nilai,
  });

  factory Kriteria.fromJson(Map<String, dynamic> json) {
    return Kriteria(
      kriteriaNama: json['kriteria_nama'],
      nilai: json['nilai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kriteria_nama': kriteriaNama,
      'nilai': nilai,
    };
  }
}

class FoodModel {
  int alternatifId;
  String alternatifNama;
  List<Kriteria> kriteria;

  FoodModel({
    required this.alternatifId,
    required this.alternatifNama,
    required this.kriteria,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    var kriteriaList = json['kriteria'] as List;
    List<Kriteria> kriteriaItems =
        kriteriaList.map((k) => Kriteria.fromJson(k)).toList();

    return FoodModel(
      alternatifId: json['alternatif_id'],
      alternatifNama: json['alternatif_nama'],
      kriteria: kriteriaItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alternatif_id': alternatifId,
      'alternatif_nama': alternatifNama,
      'kriteria': kriteria.map((k) => k.toJson()).toList(),
    };
  }
}

Future<List<FoodModel>> fetchFoods() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/food'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> parsedJson = json.decode(response.body);
    final foodsJson = parsedJson['foods'] as Map<String, dynamic>;

    // Convert JSON to list of FoodModel
    List<FoodModel> foodList = foodsJson.entries.map((entry) {
      return FoodModel.fromJson(entry.value);
    }).toList();

    return foodList;
  } else {
    throw Exception('Failed to load foods');
  }
}
