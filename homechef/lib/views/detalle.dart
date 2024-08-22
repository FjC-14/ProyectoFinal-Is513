import 'package:flutter/material.dart';
import 'package:homechef/models/receta_f.dart';

class DetalleRecetaScreen extends StatelessWidget {
  final Receta receta;

  const DetalleRecetaScreen({Key? key, required this.receta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receta.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/loaading.gif',
                      width: 100,
                      height: 100,
                    ), // GIF de carga mientras se carga la imagen
                  ),
                  Image.network(
                    receta.imagen,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Imagen cargada, muestra la imagen
                      } else {
                        return Center(
                          child: Image.asset(
                            'assets/loaading.gif', // Muestra el GIF mientras carga
                            width: 100,
                            height: 100,
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
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              receta.nombre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text('Calorías: ${receta.calorias} kcal'),
            const SizedBox(height: 10),
            Text(
              receta.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ingredientes:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            ...receta.ingredientes.map((ingrediente) => Text('- $ingrediente')),
          ],
        ),
      ),
    );
  }
}
