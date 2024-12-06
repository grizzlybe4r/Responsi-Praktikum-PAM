import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['categories'];
    } else {
      throw Exception("Gagal memuat categories");
    }
  }

  Future<List<dynamic>> fetchMealsByCategory(String category) async {
    final response =
        await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'];
    } else {
      throw Exception("Gagal memuat meals");
    }
  }

  Future<dynamic> fetchMealDetails(String idMeal) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$idMeal'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'][0];
    } else {
      throw Exception("Gagal memuat meal details");
    }
  }
}
