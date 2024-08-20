import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:homechef/models/meal_plan_model.dart';

class ApiService {
  ApiService._instantiate();
  static final ApiService instance = ApiService._instantiate();

  final String _baseURL = "api.spoonacular.com";
  static const String api_key = "2c0f41d1b3aa44b590fc912e16f4a184";

  Future<MealPlan> generateMealPlan(
      {required int targetCalories, required String diet}) async {
    Map<String, String> parameters = {
      'timeFrame': 'day',
      'targetCalories': targetCalories.toString(),
      'diet': '',
      'apiKey': api_key,
    };

    Uri uri = Uri.https(
      _baseURL,
      '/recipes/mealplans/generate',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    try {
      var response = await http.get(uri, headers: headers);

      Map<String, dynamic> data = json.decode(response.body);

      MealPlan mealPlan = MealPlan.fromMap(data);
      return mealPlan;
    } catch (err) {
      throw err.toString();
    }
  }
}
