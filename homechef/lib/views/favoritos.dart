import 'package:flutter/material.dart';
import 'package:homechef/models/receta_f.dart';
import 'package:homechef/providers/receta_f_provider.dart';
import 'package:homechef/providers/manejofav.dart';
import 'package:homechef/views/detalle.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({Key? key}) : super(key: key);

  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  late Future<List<Receta>> _favoritos;
  final FavoritosManager _favoritosManager = FavoritosManager();
  final RecetaFProvider _recetaProvider = RecetaFProvider();

  @override
  void initState() {
    super.initState();
    _favoritos = _loadFavoritos();
  }

  Future<List<Receta>> _loadFavoritos() async {
    final favoritosIds = await _favoritosManager.getFavoritos();
    final List<Receta> recetas = [];

    for (String id in favoritosIds) {
      final recetasData = await _recetaProvider.getRecetas();
      final receta = recetasData.firstWhere((receta) => receta.id == id,);
      recetas.add(receta);
        }

    return recetas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas Favoritas'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Receta>>(
        future: _favoritos,
        builder: (BuildContext context, AsyncSnapshot<List<Receta>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(
              child: Image.asset('assets/loaading.gif',),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Image.asset('assets/404.png'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No tienes recetas favoritas aún.'),
            );
          }

          final recetas = snapshot.data!;

          return ListView.builder(
            itemCount: recetas.length,
            itemBuilder: (context, index) {
              final receta = recetas[index];

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    receta.imagen,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return  SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Image.asset(
                              'assets/loaading.gif',

                            ),
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      );
                    },
                  ),
                ),
                title: Text(receta.nombre),
                subtitle: Text(receta.tipo),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetalleRecetaScreen(
                              receta: receta,
                            )),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
