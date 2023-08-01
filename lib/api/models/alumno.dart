class AlumnoFields {
  static final List<String> values = [
    id,
    nombre,
    apellidos,
    alias,
    clase,
    DNI,
    fecha_nacimiento,
    sexo,
    colegio,
    date_joined,
    user,
    // year,
    code,
    clase_nombre,
    answer
  ];

  static final String id = 'id';
  static final String nombre = 'nombre';
  static final String apellidos = 'apellidos';
  static final String alias = 'alias';
  static final String clase = 'clase';
  static final String DNI = 'DNI';
  static final String fecha_nacimiento = 'fecha_nacimiento';
  static final String sexo = 'sexo';
  static final String colegio = 'colegio';
  static final String date_joined = 'date_joined';
  static final String user = 'user';
  // static final String year = 'year';
  static final String code = 'code';
  static final String clase_nombre = 'clase_nombre';
  static final String answer = 'answer';
}

class Alumno {
  final int? id;
  String nombre;
  String apellidos;
  String? alias;
  int? clase;
  String? DNI;
  String fecha_nacimiento;
  String? sexo;
  final int? colegio;
  final String? date_joined;
  final int? user;
  // int? year;
  String? code;
  int? answer;
  String? clase_nombre;
  bool? isExpanded;

  Alumno(
      {this.id,
      required this.nombre,
      required this.apellidos,
      this.alias,
      this.clase,
      this.DNI,
      required this.fecha_nacimiento,
      this.sexo,
      this.colegio,
      this.date_joined,
      this.user,
      // this.year,
      this.code,
      this.answer,
      this.clase_nombre,
      this.isExpanded
      });

  factory Alumno.fromJson(Map<String, Object?> json) => Alumno(
      id: json[AlumnoFields.id] as int?,
      nombre: json[AlumnoFields.nombre] as String,
      apellidos: json[AlumnoFields.apellidos] as String,
      alias: json[AlumnoFields.alias] as String?,
      clase: json[AlumnoFields.clase] as int?,
      DNI: json[AlumnoFields.DNI] as String?,
      fecha_nacimiento: json[AlumnoFields.fecha_nacimiento] as String,
      sexo: json[AlumnoFields.sexo] as String,
      colegio: json[AlumnoFields.colegio] as int?,
      date_joined: json[AlumnoFields.date_joined] as String?,
      user: json[AlumnoFields.user] as int?,
      // year: json[AlumnoFields.year] as int?,
      code: json[AlumnoFields.code] as String?,
      answer: json[AlumnoFields.answer] as int?,
      clase_nombre: json[AlumnoFields.clase_nombre] as String?,
      isExpanded: false
      );

  Map<String, Object?> toJson() => {
        AlumnoFields.id: id,
        AlumnoFields.nombre: nombre,
        AlumnoFields.apellidos: apellidos,
        AlumnoFields.alias: alias,
        AlumnoFields.clase: clase,
        AlumnoFields.DNI: DNI,
        AlumnoFields.fecha_nacimiento: fecha_nacimiento,
        AlumnoFields.sexo: sexo,
        AlumnoFields.colegio: colegio,
        AlumnoFields.date_joined: date_joined,
        AlumnoFields.user: user,
        // AlumnoFields.year: year
      };

  Alumno copy(
          {int? id,
          String? nombre,
          String? apellidos,
          String? alias,
          int? clase,
          String? DNI,
          String? fecha_nacimiento,
          String? sexo,
          int? colegio,
          String? date_joined,
          int? user,
          // int? year,
          String? code,
          int? answer,
          String? clase_nombre,
          bool? isExpanded}) =>
      Alumno(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          apellidos: apellidos ?? this.apellidos,
          alias: alias ?? this.alias,
          clase: clase ?? this.clase,
          DNI: DNI ?? this.DNI,
          fecha_nacimiento: fecha_nacimiento ?? this.fecha_nacimiento,
          sexo: sexo ?? this.sexo,
          colegio: colegio ?? this.colegio,
          date_joined: date_joined ?? this.date_joined,
          user: user ?? this.user,
          // year: year ?? this.year,
          code: code ?? this.code,
          answer: answer ?? this.answer,
          clase_nombre: clase_nombre ?? this.clase_nombre,
          isExpanded: isExpanded ?? this.isExpanded
          );
}
