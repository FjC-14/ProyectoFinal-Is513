import "package:flutter/material.dart";
import 'package:homechef/providers/receta_f_provider.dart';
import 'package:homechef/models/receta_f.dart';
import 'package:homechef/views/busqueda.dart';
import 'package:homechef/views/detalle.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final recetas = RecetaFProvider();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Chef"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen(recetaFProvider: recetas)) );//esta linea da error 
          },
          icon: const Icon(Icons.search))
        ],
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DetalleRecetaScreen(receta: receta)));
                    },
                  );
                });
          }),
    );
  }
}
