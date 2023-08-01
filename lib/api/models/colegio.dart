class ColegioFields {
  static final List<String> values = [
    id,
    nombre,
    email,
    fecha_inicio,
    localidad
  ];

  static final String id = 'id';
  static final String nombre = 'nombre';
  static final String email = 'email';
  static final String fecha_inicio = 'fecha_inicio';
  static final String localidad = 'localidad';
  
}

class Colegio {
  final int? id;
  String nombre;
  String email;
  String? fecha_inicio;
  String localidad;
  bool? isExpanded;

  Colegio(
      {this.id,
      required this.nombre,
      required this.email,
      this.fecha_inicio,
      required this.localidad,
      this.isExpanded
      });

  factory Colegio.fromJson(Map<String, Object?> json) => Colegio(
      id: json[ColegioFields.id] as int?,
      nombre: json[ColegioFields.nombre] as String,
      email: json[ColegioFields.email] as String,
      fecha_inicio: json[ColegioFields.fecha_inicio] as String?,
      localidad: json[ColegioFields.localidad] as String,
      isExpanded: false
      );

  Map<String, Object?> toJson() => {
        ColegioFields.id: id,
        ColegioFields.nombre: nombre,
        ColegioFields.email: email,
        ColegioFields.fecha_inicio: fecha_inicio,
        ColegioFields.localidad: localidad
      };

  Colegio copy(
          {int? id,
          String? nombre,
          String? email,
          String? fecha_inicio,
          String? localidad,
          bool? isExpanded}) =>
      Colegio(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          email: email ?? this.email,
          fecha_inicio: fecha_inicio ?? this.fecha_inicio,
          localidad: localidad ?? this.localidad,
          isExpanded: isExpanded ?? this.isExpanded
          );
}
