import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nutritionalapp/models/foodlist.dart';
import 'package:nutritionalapp/models/nutrients_food.dart';

class Api {
  List<Food> foods = [];
  Map<String, dynamic> mapa = {};

  Future<List<Food>> getFood(String aliment) async {
    final response = await http.Client().get(Uri.parse(
        "https://api.spoonacular.com/food/ingredients/search?query=$aliment&number=10&apiKey=77da9e1c9fa44336bd5dfeaf2dec531b"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      print(data["results"]);
      foods = ListFood.foodFromJson(data["results"]);
      print(foods);
    } else {
      throw Exception("No funcionó el llamado a la api");
    }

    return foods;
  }

  Future<Map<String, dynamic>> getMacroNutrients(int id) async {
    final response = await http.Client().get(Uri.parse(
        "https://api.spoonacular.com/food/ingredients/$id/information?amount=150&unit=grams&apiKey=77da9e1c9fa44336bd5dfeaf2dec531b"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      print(data["results"]);
      mapa = Macronutrients.fromJson(data["nutrients"]["caloricBreakdown"])
          as Map<String, dynamic>;
      print(foods);
    } else {
      throw Exception("No funcionó el llamado a la api");
    }

    return mapa;
  }
}
