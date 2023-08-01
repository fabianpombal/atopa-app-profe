class PreguntaFields {
  static final List<String> values = [
    id,
    pregunta,
    tipo_estructura,
    tipo_pregunta,
    grupo_edad,
    tipo_estructura_nombre,
    tipo_pregunta_nombre,
    grupo_edad_nombre,
  ];

  static final String id = 'id';
  static final String pregunta = 'pregunta';
  static final String tipo_estructura = 'tipo_estructura';
  static final String tipo_pregunta = 'tipo_pregunta';
  static final String grupo_edad = 'grupo_edad';
  static final String tipo_estructura_nombre = 'tipo_estructura_nombre';
  static final String tipo_pregunta_nombre = 'tipo_pregunta_nombre';
  static final String grupo_edad_nombre = 'grupo_edad_nombre';
  
}

class Pregunta {
  final int? id;
  String pregunta;
  int tipo_estructura;
  int tipo_pregunta;
  int grupo_edad;
  String? tipo_estructura_nombre;
  String? tipo_pregunta_nombre;
  String? grupo_edad_nombre;
  bool? isExpanded;

  Pregunta(
      {this.id,
      required this.pregunta,
      required this.tipo_estructura,
      required this.tipo_pregunta,
      required this.grupo_edad,
      this.tipo_estructura_nombre,
      this.tipo_pregunta_nombre,
      this.grupo_edad_nombre,
      this.isExpanded,
      });

  factory Pregunta.fromJson(Map<String, Object?> json) => Pregunta(
      id: json[PreguntaFields.id] as int?,
      pregunta: json[PreguntaFields.pregunta] as String,
      tipo_estructura: json[PreguntaFields.tipo_estructura] as int,
      tipo_pregunta: json[PreguntaFields.tipo_pregunta] as int,
      grupo_edad: json[PreguntaFields.grupo_edad] as int,
      tipo_estructura_nombre: json[PreguntaFields.tipo_estructura_nombre] as String?,
      tipo_pregunta_nombre: json[PreguntaFields.tipo_pregunta_nombre] as String?,
      grupo_edad_nombre: json[PreguntaFields.grupo_edad_nombre] as String?,
      isExpanded: false,
      );

  Map<String, Object?> toJson() => {
        PreguntaFields.id: id,
        PreguntaFields.pregunta: pregunta,
        PreguntaFields.tipo_estructura: tipo_estructura,
        PreguntaFields.tipo_pregunta: tipo_pregunta,
        PreguntaFields.grupo_edad: grupo_edad
      };

  Pregunta copy(
          {int? id,
          String? pregunta,
          int? tipo_estructura,
          int? tipo_pregunta,
          int? grupo_edad,
          String? tipo_estructura_nombre,
          String? tipo_pregunta_nombre,
          String? grupo_edad_nombre,
          bool? isExpanded,
          }) =>
      Pregunta(
          id: id ?? this.id,
          pregunta: pregunta ?? this.pregunta,
          tipo_estructura: tipo_estructura ?? this.tipo_estructura,
          tipo_pregunta: tipo_pregunta ?? this.tipo_pregunta,
          grupo_edad: grupo_edad ?? this.grupo_edad,
          tipo_estructura_nombre: tipo_estructura_nombre ?? this.tipo_estructura_nombre,
          tipo_pregunta_nombre: tipo_pregunta_nombre ?? this.tipo_pregunta_nombre,
          grupo_edad_nombre: grupo_edad_nombre ?? this.grupo_edad_nombre,
          isExpanded: isExpanded ?? this.isExpanded,
          );
}
