class Receta {
    String id;
    String nombre;
    String imagen;
    int calorias;
    String descripcion;
    String tipo;
    List<String> ingredientes;
    List <String> preparacion;

    Receta({
        required this.id,
        required this.nombre,
        required this.imagen,
        required this.calorias,
        required this.descripcion,
        required this.tipo,
        required this.ingredientes,
        required this.preparacion,
    });

    factory Receta.fromJson(Map<String, dynamic> json) => Receta(
        id: json["id"],
        nombre: json["nombre"],
        imagen: json["imagen"],
        calorias: json["calorias"],
        descripcion: json["descripcion"],
        tipo: json["tipo"],
        ingredientes: List<String>.from(json['ingredientes']?? []),
        preparacion: List<String>.from(json['preparacion']?? [])
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "imagen": imagen,
        "calorias": calorias,
        "descripcion": descripcion,
        "tipo": tipo,
        "ingredientes": ingredientes,
        "preparacion": preparacion,
    };
}
