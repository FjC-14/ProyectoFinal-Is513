import "package:flutter/material.dart";
import 'package:homechef/providers/receta_f_provider.dart';
import 'package:homechef/models/receta_f.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final recetas = RecetaFProvider();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Chef"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: recetas.getRecetas(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Receta>> snapshot) {
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
                    title: Text(receta.nombre),
                    subtitle: Text(receta.tipo),
                  );
                });
          }),
    );
  }
}
