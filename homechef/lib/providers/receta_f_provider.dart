import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:homechef/models/receta_f.dart';

class RecetaFProvider {
  Future<List<Receta>> getRecetas() async {
    try {
      final Uri url = Uri.https(
          'recetasapi-32189-default-rtdb.firebaseio.com', '/recetas.json');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> paredResponse = json.decode(response.body);

        final List<Receta> recetas = paredResponse.map((json){
          return Receta.fromJson(json as Map<String, dynamic>);
        }
        ).toList();

        return recetas;
      }
      return [];
    } catch (error) {
      throw Exception(error);
    }

    
  }
}
