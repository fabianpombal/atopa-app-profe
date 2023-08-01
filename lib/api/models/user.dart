class UserFields {
  static final List<String> values = [
    profesor,
    nombre,
    apellidos,
    DNI,
    colegio,
    date_joined,
    rol,
    user,
    validado,
    evaluacion,
    email,
    username
  ];

  static final String profesor = 'profesor';
  static final String nombre = 'nombre';
  static final String apellidos = 'apellidos';
  static final String DNI = 'DNI';
  static final String colegio = 'colegio';
  static final String date_joined = 'date_joined';
  static final String rol = 'rol';
  static final String user = 'user';
  static final String validado = 'validado';
  static final String evaluacion = 'evaluacion';
  static final String email = 'email';
  static final String username = 'username';
  static final String password = 'password';
  static final String password2 = 'password2';
}

class User {
  final int? profesor;
  String nombre;
  String apellidos;
  String? DNI;
  int? colegio;
  final String? date_joined;
  int? rol;
  final int? user;
  final int? validado;
  int evaluacion;
  String email;
  String username;
  String? password;
  String? password2;

  User(
      {this.profesor,
      required this.nombre,
      required this.apellidos,
      this.DNI,
      this.colegio,
      this.date_joined,
      this.rol,
      this.user,
      this.validado,
      required this.evaluacion,
      required this.email,
      required this.username,
      this.password,
      this.password2
      });

  factory User.fromJson(Map<String, Object?> json) => User(
      profesor: json[UserFields.profesor] as int?,
      nombre: json[UserFields.nombre] as String,
      apellidos: json[UserFields.apellidos] as String,
      DNI: json[UserFields.DNI] as String?,
      colegio: json[UserFields.colegio] as int?,
      date_joined: json[UserFields.date_joined] as String?,
      rol: json[UserFields.rol] as int?,
      user: json[UserFields.user] as int?,
      validado: json[UserFields.user] as int?,
      evaluacion: json[UserFields.evaluacion] as int,
      email: json[UserFields.email] as String,
      username: json[UserFields.username] as String
      );

  Map<String, Object?> toJson() => {
        UserFields.profesor: profesor,
        UserFields.nombre: nombre,
        UserFields.apellidos: apellidos,
        UserFields.DNI: DNI,
        UserFields.colegio: colegio,
        UserFields.date_joined: date_joined,
        UserFields.rol: rol,
        UserFields.user: user,
        UserFields.validado: validado,
        UserFields.evaluacion: evaluacion,
        UserFields.email: email,
        UserFields.username: username,
        UserFields.password: password
      };

  User copy(
          {int? profesor,
          String? nombre,
          String? apellidos,
          String? DNI,
          int? colegio,
          String? date_joined,
          int? rol,
          int? user,
          int? validado,
          int? evaluacion,
          String? email,
          String? username,
          String? password,
          String? password2}) =>
      User(
          profesor: profesor ?? this.profesor,
          nombre: nombre ?? this.nombre,
          apellidos: apellidos ?? this.apellidos,
          DNI: DNI ?? this.DNI,
          colegio: colegio ?? this.colegio,
          date_joined: date_joined ?? this.date_joined,
          rol: rol ?? this.rol,
          user: user ?? this.user,
          validado: validado ?? this.validado,
          evaluacion: evaluacion ?? this.evaluacion,
          email: email ?? this.email,
          username: username ?? this.username,
          password: password ?? this.password,
          password2: password2 ?? this.password2
          );
}
