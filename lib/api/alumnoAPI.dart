import 'dart:convert';
import 'package:atopa_app_flutter/api/models/alumno.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
 import 'package:http_parser/http_parser.dart';
import 'baseAPI.dart';

class AlumnoAPI extends BaseAPI {


  Future<List<Alumno>> getAlumnos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.get(Uri.parse(super.studentsPath),
        headers: super.addToken(token));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['alumnos'];
      List<Alumno> list = jsonResponse.map((data) => new Alumno.fromJson(data)).toList();
      return list;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getAlumnos();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Alumno>> getAlumnosSearch(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.post(Uri.parse(super.studentsSearchPath),
        headers: super.addToken(token), body: json.encode(body));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['alumnos'];
      List<Alumno> list = jsonResponse.map((data) => new Alumno.fromJson(data)).toList();
      return list;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getAlumnosSearch(body);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> newAlumno(Alumno alumno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.post(Uri.parse(super.studentsPath),
        headers: super.addToken(token), body: json.encode(alumno.toJson()));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return newAlumno(alumno);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> updateAlumno(Map<String, dynamic> body, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.put(Uri.parse(super.studentPath + "/" + id.toString()),
        headers: super.addToken(token), body: json.encode(body));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return updateAlumno(body, id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> deleteAlumno(Alumno alumno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.delete(Uri.parse(super.studentPath + "/" + alumno.id.toString()),
        headers: super.addToken(token));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return deleteAlumno(alumno);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.StreamedResponse> uploadExcel(List<int> _selectedFile, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    // http.Response response = await http.get(Uri.parse(super.studentsPath),
    //     headers: super.addToken(token));
    var request = new http.MultipartRequest("POST", Uri.parse(super.importPath));
    super.addToken(token).forEach((k, v) {
      request.headers[k] = v;
    });
    request.files.add(http.MultipartFile.fromBytes('file', _selectedFile,
      contentType: new MediaType('application', 'octet-stream'),
      filename: "alumnos-" + id.toString() + ".xlsx"));

    http.StreamedResponse response = await request.send();
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return uploadExcel(_selectedFile, id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

}