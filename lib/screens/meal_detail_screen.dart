// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class MealDetailScreen extends StatelessWidget {
  final String idMeal;

  const MealDetailScreen({Key? key, required this.idMeal}) : super(key: key);

  // Fungsi untuk membuka URL di browser
  void _launchURL(String url) async {
    if (url.isEmpty || !url.startsWith('http')) {
      throw 'Invalid URL: $url';
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ApiService _apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Makanan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[600],
      ),
      body: FutureBuilder<dynamic>(
        future: _apiService.fetchMealDetails(idMeal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final meal = snapshot.data!;

            // Mengambil daftar ingredients
            final ingredients = <String>[];
            for (var i = 1; i <= 20; i++) {
              final ingredient = meal['strIngredient$i'];
              final measure = meal['strMeasure$i'];
              if (ingredient != null && ingredient.isNotEmpty) {
                ingredients.add('$ingredient ($measure)');
              }
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar makanan
                  Image.network(meal['strMealThumb']),

                  // Nama makanan
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      meal['strMeal'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Kategori dan Area
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kategori: ${meal['strCategory']}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Asal: ${meal['strArea']}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),

                  // Ingredients
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Bahan-Bahan:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ingredients
                          .map((ingredient) => Text(
                                "- $ingredient",
                                style: TextStyle(fontSize: 16),
                              ))
                          .toList(),
                    ),
                  ),

                  // Instructions
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Langkah-Langkah:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      meal['strInstructions'],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  // Tombol Lihat Video Tutorial
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          final url = meal['strYoutube'];
                          _launchURL(url); // Buka URL dengan url_launcher
                        },
                        child: Text("Lihat Video Tutorial"),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
