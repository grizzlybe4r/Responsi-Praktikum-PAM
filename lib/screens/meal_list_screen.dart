import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import 'meal_detail_screen.dart';

class MealListScreen extends StatelessWidget {
  final String category;

  const MealListScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiService _apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Makanan: $category",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[600],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _apiService.fetchMealsByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final meals = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailScreen(
                          idMeal: meal['idMeal'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Gambar di atas
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: meal['strMealThumb'],
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Nama makanan di bawah
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            meal['strMeal'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
