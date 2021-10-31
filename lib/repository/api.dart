import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nutritionalapp/models/foodlist.dart';

class Api {
  List<Food> foods = [];

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
}
