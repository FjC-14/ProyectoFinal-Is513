import 'package:shared_preferences/shared_preferences.dart';

class FavoritosManager {
  static const String favoritosKey = 'favoritos';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<String>> getFavoritos() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList(favoritosKey) ?? [];
  }

  Future<void> addFavorito(String recetaId) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favoritos = prefs.getStringList(favoritosKey) ?? [];
    if (!favoritos.contains(recetaId)) {
      favoritos.add(recetaId);
      prefs.setStringList(favoritosKey, favoritos);
    }
  }

  Future<void> removeFavorito(String recetaId) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favoritos = prefs.getStringList(favoritosKey) ?? [];
    if (favoritos.contains(recetaId)) {
      favoritos.remove(recetaId);
      prefs.setStringList(favoritosKey, favoritos);
    }
  }

  Future<bool> isFavorito(String recetaId) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favoritos = prefs.getStringList(favoritosKey) ?? [];
    return favoritos.contains(recetaId);
  }
}
