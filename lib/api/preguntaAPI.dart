import 'dart:convert';
import 'package:atopa_app_flutter/api/models/pregunta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'baseAPI.dart';

class PreguntaAPI extends BaseAPI {

  Future<List<Pregunta>> getPreguntasSearch(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.post(Uri.parse(super.preguntasSearchPath),
        headers: super.addToken(token), body: json.encode(body));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['preguntas'];

      List<Pregunta> list = jsonResponse.map((data) => new Pregunta.fromJson(data)).toList();
      return list;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getPreguntasSearch(body);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<Map<String, List<Pregunta>>> getPreguntasTestSearch(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.post(Uri.parse(super.preguntasTestSearchPath),
        headers: super.addToken(token), body: json.encode(body));
    if (response.statusCode == 200) {
      Map<String, List<Pregunta>> preguntas = {};
      List jsonResponse1 = json.decode(response.body)['preguntas1'];
      List<Pregunta> list1 = jsonResponse1.map((data) => new Pregunta.fromJson(data)).toList();
      List jsonResponse2 = json.decode(response.body)['preguntas2'];
      List<Pregunta> list2 = jsonResponse2.map((data) => new Pregunta.fromJson(data)).toList();
      List jsonResponse3 = json.decode(response.body)['preguntas3'];
      List<Pregunta> list3 = jsonResponse3.map((data) => new Pregunta.fromJson(data)).toList();
      List jsonResponse4 = json.decode(response.body)['preguntas4'];
      List<Pregunta> list4 = jsonResponse4.map((data) => new Pregunta.fromJson(data)).toList();
      List jsonResponse5 = json.decode(response.body)['preguntas5'];
      List<Pregunta> list5 = jsonResponse5.map((data) => new Pregunta.fromJson(data)).toList();
      List jsonResponse6 = json.decode(response.body)['preguntas6'];
      List<Pregunta> list6 = jsonResponse6.map((data) => new Pregunta.fromJson(data)).toList();
      preguntas['preguntas1'] = list1;
      preguntas['preguntas2'] = list2;
      preguntas['preguntas3'] = list3;
      preguntas['preguntas4'] = list4;
      preguntas['preguntas5'] = list5;
      preguntas['preguntas6'] = list6;
      return preguntas;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getPreguntasTestSearch(body);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> newPregunta(Pregunta pregunta) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.post(Uri.parse(super.preguntasPath),
        headers: super.addToken(token), body: json.encode(pregunta.toJson()));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return newPregunta(pregunta);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> updatePregunta(Map<String, dynamic> body, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.put(Uri.parse(super.preguntaPath + "/" + id.toString()),
        headers: super.addToken(token), body: json.encode(body));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return updatePregunta(body, id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> deletePregunta(Pregunta pregunta) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.delete(Uri.parse(super.preguntaPath + "/" + pregunta.id.toString()),
        headers: super.addToken(token));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return deletePregunta(pregunta);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

}