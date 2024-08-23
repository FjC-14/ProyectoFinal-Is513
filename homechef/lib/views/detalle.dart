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
            Center(
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/loaading.gif',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Image.network(
                    widget.receta.imagen,
                    width: double.infinity,
                    height: 250,
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
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.receta.nombre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text('Calorías: ${widget.receta.calorias} kcal'),
            const SizedBox(height: 10),
            Text(
              widget.receta.descripcion,
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
            ...widget.receta.ingredientes.map((ingrediente) => Text('- $ingrediente')),
            const SizedBox(height: 20),
            const Text(
              'Preparación:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            ...widget.receta.preparacion.map((paso) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '${widget.receta.preparacion.indexOf(paso) + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(paso),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
