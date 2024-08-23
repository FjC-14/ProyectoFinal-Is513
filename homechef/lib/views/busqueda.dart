import 'package:flutter/material.dart';
import 'package:homechef/providers/receta_f_provider.dart';
import 'package:homechef/models/receta_f.dart';
import 'package:homechef/views/detalle.dart';

class SearchScreen extends StatefulWidget {
  final RecetaFProvider recetaFProvider;

  const SearchScreen({Key? key, required this.recetaFProvider}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Receta> _filteredRecetas = [];
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Recetas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nombre, tipo o ingredientes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _query = query.toLowerCase();
                });
                _searchRecetas();
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _filteredRecetas.isEmpty && _query.isNotEmpty
                  ? const Center(child: Text('No se encontraron recetas'))
                  : ListView.builder(
                      itemCount: _filteredRecetas.length,
                      itemBuilder: (context, index) {
                        final receta = _filteredRecetas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.network(
                                  receta.imagen,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
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
                            ),
                            title: Text(
                              receta.nombre,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              receta.tipo,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetalleRecetaScreen(receta: receta)),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchRecetas() async {
    final allRecetas = await widget.recetaFProvider.getRecetas();
    setState(() {
      _filteredRecetas = allRecetas.where((receta) {
        final nombre = receta.nombre.toLowerCase();
        final ingredientes = receta.ingredientes.join(' ').toLowerCase();
        final tipo = receta.tipo.toLowerCase();
        return nombre.contains(_query) || ingredientes.contains(_query) || tipo.contains(_query);
      }).toList();
    });
  }
}
