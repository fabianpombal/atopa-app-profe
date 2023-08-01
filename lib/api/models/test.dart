import 'package:atopa_app_flutter/api/models/pregunta.dart';

class TestFields {
  static final List<String> values = [
    id,
    nombre,
    estructura,
    uploaded,
    clase,
    downloaded,
    profesor,
    closed,
    first,
    date_created,
    followUp,
    year,
    survey1,
    survey2,
    estructura_nombre,
    clase_nombre,
    preguntas,
    grupo_edad,
    fin
  ];

  static final String id = 'id';
  static final String nombre = 'nombre';
  static final String estructura = 'estructura';
  static final String uploaded = 'uploaded';
  static final String clase = 'clase';
  static final String downloaded = 'downloaded';
  static final String profesor = 'profesor';
  static final String closed = 'closed';
  static final String first = 'first';
  static final String date_created = 'date_created';
  static final String followUp = 'followUp';
  static final String year = 'year';
  static final String survey1 = 'survey1';
  static final String survey2 = 'survey2';
  static final String estructura_nombre = "estructura_nombre";
  static final String clase_nombre = "clase_nombre";
  static final String preguntas = "preguntas";
  static final String grupo_edad = "grupo_edad";
  static final String fin = "final";
  static final String grupo_edad_nombre = "grupo_edad_nombre";
}

class Test {
  int? id;
  String nombre;
  int? estructura;
  int uploaded;
  int? clase;
  int downloaded;
  int? profesor;
  int closed;
  int? first;
  final String? date_created;
  int followUp;
  int survey1;
  int survey2;
  int? year;
  bool? isExpanded;
  String? estructura_nombre;
  String? clase_nombre;
  List<dynamic>? preguntas;
  int? grupo_edad;
  int? fin;
  String? grupo_edad_nombre;

  Test(
      {this.id,
      required this.nombre,
      this.estructura,
      required this.uploaded,
      this.clase,
      required this.downloaded,
      this.profesor,
      required this.closed,
      this.first,
      this.date_created,
      required this.followUp,
      required this.survey1,
      required this.survey2,
      this.year,
      this.isExpanded,
      this.estructura_nombre,
      this.clase_nombre,
      this.preguntas,
      this.grupo_edad,
      this.fin,
      this.grupo_edad_nombre
      });

  factory Test.fromJson(Map<String, Object?> json) => Test(
      id: json[TestFields.id] as int?,
      nombre: json[TestFields.nombre] as String,
      estructura: json[TestFields.estructura] as int,
      uploaded: json[TestFields.uploaded] as int,
      clase: json[TestFields.clase] as int,
      downloaded: json[TestFields.downloaded] as int,
      profesor: json[TestFields.profesor] as int?,
      closed: json[TestFields.closed] as int,
      first: json[TestFields.first] as int?,
      date_created: json[TestFields.date_created] as String?,
      followUp: json[TestFields.followUp] as int,
      survey1: json[TestFields.survey1] as int,
      survey2: json[TestFields.survey2] as int,
      year: json[TestFields.year] as int?,
      isExpanded: false,
      estructura_nombre: json[TestFields.estructura_nombre] as String?,
      clase_nombre: json[TestFields.clase_nombre] as String?,
      grupo_edad: json[TestFields.grupo_edad] as int?,
      preguntas: (json[TestFields.preguntas] as List).map((data) => new Pregunta.fromJson(data)).toList(),
      fin: json[TestFields.fin] as int? ,
      grupo_edad_nombre: json[TestFields.grupo_edad_nombre] as String?
      );

  Map<String, Object?> toJson() => {
        TestFields.id: id,
        TestFields.nombre: nombre,
        TestFields.estructura: estructura,
        TestFields.uploaded: uploaded,
        TestFields.clase: clase,
        TestFields.downloaded: downloaded,
        TestFields.profesor: profesor,
        TestFields.closed: closed,
        TestFields.first: first,
        TestFields.date_created: date_created,
        TestFields.followUp: followUp,
        TestFields.survey1: survey1,
        TestFields.survey2: survey2,
        TestFields.year: year,
        TestFields.preguntas: preguntas,
        TestFields.fin: fin
      };

  Test copy(
          {int? id,
          String? nombre,
          int? estructura,
          int? uploaded,
          int? clase,
          int? downloaded,
          int? profesor,
          int? closed,
          int? first,
          String? date_created,
          int? followUp,
          int? survey1,
          int? survey2,
          int? year,
          bool? isExpanded,
          String? estructura_nombre,
          String? clase_nombre,
          List<dynamic>? preguntas,
          int? grupo_edad,
          int? fin,
          String? grupo_edad_nombre}) =>
      Test(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          estructura: estructura ?? this.estructura,
          uploaded: uploaded ?? this.uploaded,
          clase: clase ?? this.clase,
          downloaded: downloaded ?? this.downloaded,
          profesor: profesor ?? this.profesor,
          closed: closed ?? this.closed,
          first: first ?? this.first,
          date_created: date_created ?? this.date_created,
          followUp: followUp ?? this.followUp,
          survey1: survey1 ?? this.survey1,
          survey2: survey2 ?? this.survey2,
          year: year ?? this.year,
          isExpanded: isExpanded ?? this.isExpanded,
          estructura_nombre: estructura_nombre ?? this.estructura_nombre,
          clase_nombre: clase_nombre ?? this.clase_nombre,
          preguntas: preguntas ?? this.preguntas,
          grupo_edad: grupo_edad ?? this.grupo_edad,
          fin: fin ?? this.fin,
          grupo_edad_nombre: grupo_edad_nombre ?? this.grupo_edad_nombre
          );
}
