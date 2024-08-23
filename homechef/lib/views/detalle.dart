import 'package:flutter/material.dart';
import 'package:homechef/models/receta_f.dart';
import 'package:homechef/providers/manejofav.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;

  const DetalleRecetaScreen({Key? key, required this.receta}) : super(key: key);

  @override
  _DetalleRecetaScreenState createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  bool isFavorito = false;
  final FavoritosManager favoritosManager = FavoritosManager();

  @override
  void initState() {
    super.initState();
    _checkIfFavorito();
  }

  void _checkIfFavorito() async {
    isFavorito = await favoritosManager.isFavorito(widget.receta.id);
    setState(() {});
  }

  void _toggleFavorito() async {
    if (isFavorito) {
      await favoritosManager.removeFavorito(widget.receta.id);
    } else {
      await favoritosManager.addFavorito(widget.receta.id);
    }
    setState(() {
      isFavorito = !isFavorito;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receta.nombre),
        actions: [
          IconButton(
            icon: Icon(isFavorito ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorito,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la receta
            Center(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        widget.receta.imagen,
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
                          return const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Título y calorías
            Text(
              widget.receta.nombre,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Calorías: ${widget.receta.calorias} kcal',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            // Descripción
            Text(
              widget.receta.descripcion,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            // Ingredientes
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingredientes:',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...widget.receta.ingredientes.map((ingrediente) => Text(
                        '- $ingrediente',
                        style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
            // Preparación
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preparación:',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...widget.receta.preparacion.map((paso) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                '${widget.receta.preparacion.indexOf(paso) + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            title: Text(paso),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
