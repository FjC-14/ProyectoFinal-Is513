import 'package:flutter/material.dart';
import 'package:homechef/providers/receta_f_provider.dart';
import 'package:homechef/models/receta_f.dart';
import 'package:homechef/views/busqueda.dart';
import 'package:homechef/views/detalle.dart';
import 'package:homechef/views/favoritos.dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final recetas = RecetaFProvider();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    switch (_selectedIndex) {
      case 1:
        currentScreen = const FavoritosScreen();  // Pantalla de favoritos
        break;
      case 2:
        currentScreen =const Placeholder();  // Placeholder para la tercera pantalla
        break;
      default:
        currentScreen = FutureBuilder(
          future: recetas.getRecetas(),
          builder: (BuildContext context, AsyncSnapshot<List<Receta>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No hay Datos'),
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
                            return const SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(),
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
                            builder: (context) =>
                                DetalleRecetaScreen(receta: receta)),
                      );
                    },
                  );
                });
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Chef"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SearchScreen(recetaFProvider: recetas)));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Otra función',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
