import 'package:atopa_app_flutter/api/models/alumno.dart';

class ClaseFields {
  static final List<String> values = [
    id,
    nombre,
    grupo_edad,
    modify,
    teacher,
    year,
    alumnos
  ];

  static final String id = 'id';
  static final String nombre = 'nombre';
  static final String grupo_edad = 'grupo_edad';
  static final String modify = 'modify';
  static final String teacher = 'teacher';
  static final String year = 'year';
  static final String alumnos = 'alumnos';
  
}

class Clase {
  final int? id;
  String nombre;
  int? grupo_edad;
  int modify;
  int? teacher;
  int? year;
  bool? isExpanded;
  List<Alumno>? alumnos;

  Clase(
      {this.id,
      required this.nombre,
      this.grupo_edad,
      required this.modify,
      this.teacher,
      this.year,
      this.isExpanded,
      this.alumnos
      });

  factory Clase.fromJson(Map<String, Object?> json) => Clase(
      id: json[ClaseFields.id] as int?,
      nombre: json[ClaseFields.nombre] as String,
      grupo_edad: json[ClaseFields.grupo_edad] as int?,
      modify: json[ClaseFields.modify] as int,
      teacher: json[ClaseFields.teacher] as int?,
      year: json[ClaseFields.year] as int?,
      isExpanded: false,
      alumnos: (json[ClaseFields.alumnos] as List).map((data) => new Alumno.fromJson(data)).toList()
      );

  Map<String, Object?> toJson() => {
        ClaseFields.id: id,
        ClaseFields.nombre: nombre,
        ClaseFields.grupo_edad: grupo_edad,
        ClaseFields.modify: modify,
        ClaseFields.teacher: teacher,
        ClaseFields.year: year,
        ClaseFields.alumnos: (alumnos as List).map((data) => (data as Alumno).toJson()).toList()
      };

  Clase copy(
          {int? id,
          String? nombre,
          int? grupo_edad,
          int? modify,
          int? teacher,
          int? year,
          bool? isExpanded,
          List<Alumno>? alumnos}) =>
      Clase(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          grupo_edad: grupo_edad ?? this.grupo_edad,
          modify: modify ?? this.modify,
          teacher: teacher ?? this.teacher,
          year: year ?? this.year,
          isExpanded: isExpanded ?? this.isExpanded,
          alumnos: alumnos ?? this.alumnos
          );
}
