class BaseAPI {
  static String base = "https://localhost:5010";
  // static String base = "https://193.146.210.237:5010";

  var studentsPath = base + "/alumnos";
  var studentPath = base + "/alumno";
  var studentsSearchPath = base + "/alumnosSearch";
  var importPath = base + "/importAlumnos";

  var loginPath = base + "/auth/login";
  var logoutPath = base + "/auth/logout";
  var signUpPath = base + "/auth/signup";
  var loggedPath = base + "/auth/userProfesor";
  var refresh = base + "/auth/refresh";
  var preferenciasUser = base + "/preferenciaUser";
  var preferencias = base + "/preferencia";
  var teacherPath = base + "/profesor";

  var clasesPath = base + "/clases";
  var clasePath = base + "/clase";
  var clasesSearchPath = base + "/clasesSearch";

  var colegiosPath = base + "/colegios";
  var colegioPath = base + "/colegio";
  var colegioUserPath = base + "/colegioUser";

  var yearsPath = base + "/years";

  var testsPath = base + "/tests";
  var testPath = base + "/test";
  var testsSearchPath = base + "/testsSearch";
  var openTestPath = base + "/openTest";
  var closeTestPath = base + "/closeTest";
  var followUpPath = base + "/followUpTest";
  var codes = base + "/codesTest";

  var encuestasPath = base + "/encuestas";
  var encuestaPath = base + "/encuesta";

  var preguntasPath = base + "/preguntas";
  var preguntaPath = base + "/pregunta";
  var preguntasSearchPath = base + "/preguntasSearch";
  var preguntasTestSearchPath = base + "/preguntasTestSearch";

  var allPdf = base + "/informePdfAlumnos";
  var studentPdf = base + "/informePdfAlumno";
  var testPdf = base + "/informePdfTest";

  var informeStudent = base + "/informeAlumno";
  var informeTest = base + "/informeTest";

  var resultsPath = base + "/resultados";
  var checkResults = base + "/checkResultados";
  // more routes

  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };

  Map<String, String> addToken(String token) => {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer " + token
      };
}
