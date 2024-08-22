import 'package:flutter/material.dart';
import 'package:homechef/providers/receta_f_provider.dart';
import 'package:homechef/models/receta_f.dart';
import 'package:homechef/views/detalle.dart';
import 'package:homechef/Widgets/textform.dart';


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
                labelText: 'Buscar por nombre o ingredientes',
                border: OutlineInputBorder(),
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
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(receta.nombre),
                            subtitle: Text(receta.tipo),
                            onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetalleRecetaScreen(receta: receta)));
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
        return nombre.contains(_query) || ingredientes.contains(_query);
      }).toList();
    });
  }
}
