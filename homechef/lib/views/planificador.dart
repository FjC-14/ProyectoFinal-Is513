import 'package:flutter/material.dart';
import 'package:homechef/models/receta_f.dart';
import 'package:homechef/providers/receta_f_provider.dart';
import 'package:homechef/views/detalle.dart';

class PlanificadorDeComidas extends StatefulWidget {
  final RecetaFProvider recetaProvider;

  const PlanificadorDeComidas({Key? key, required this.recetaProvider})
      : super(key: key);

  @override
  _PlanificadorDeComidasState createState() => _PlanificadorDeComidasState();
}

class _PlanificadorDeComidasState extends State<PlanificadorDeComidas> {
  final TextEditingController _caloriasController = TextEditingController();
  List<Receta> _recetasPlanificadas = [];
  String _mensaje = '';

  Future<void> _planificarComidas() async {
    int caloriasDeseadas = int.tryParse(_caloriasController.text) ?? 0;
    List<Receta> todasLasRecetas = await widget.recetaProvider.getRecetas();

    List<Receta> recetasSeleccionadas = [];

    for (var receta in todasLasRecetas) {
      int sumCalorias = receta.calorias;
      recetasSeleccionadas = [receta];

      for (var otraReceta in todasLasRecetas) {
        if (otraReceta != receta &&
            sumCalorias + otraReceta.calorias <= caloriasDeseadas) {
          sumCalorias += otraReceta.calorias;
          recetasSeleccionadas.add(otraReceta);
        }

        if (recetasSeleccionadas.length == 3 &&
            sumCalorias == caloriasDeseadas) {
          setState(() {
            _recetasPlanificadas = recetasSeleccionadas;
            _mensaje = '';
          });
          return;
        }
      }
    }

    setState(() {
      _recetasPlanificadas = [];
      _mensaje =
          'No se encontraron recetas que coincidan con las calorías deseadas.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planificador de Comidas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _caloriasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calorías deseadas',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _planificarComidas,
                child: const Text('Planificar'),
              ),
              const SizedBox(height: 20),
              _recetasPlanificadas.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _recetasPlanificadas.length,
                      itemBuilder: (context, index) {
                        final receta = _recetasPlanificadas[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              receta.imagen,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
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
                          subtitle: Text('${receta.calorias} kcal'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetalleRecetaScreen(receta: receta),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Text(_mensaje),
            ],
          ),
        ),
      ),
    );
  }
}
