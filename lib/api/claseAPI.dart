import 'dart:convert';
import 'package:atopa_app_flutter/api/models/clase.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'baseAPI.dart';

class ClaseAPI extends BaseAPI {


  Future<List<Clase>> getClases() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.get(Uri.parse(super.clasesPath),
        headers: super.addToken(token));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['clases'];
      List<Clase> list = jsonResponse.map((data) => new Clase.fromJson(data)).toList();
      return list;
    } else if (response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getClases();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Clase>> getClasesSearch(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.post(Uri.parse(super.clasesSearchPath),
        headers: super.addToken(token), body: json.encode(body));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['clases'];
      List<Clase> list = jsonResponse.map((data) => new Clase.fromJson(data)).toList();
      return list;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getClasesSearch(body);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> newClase(Clase clase) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.post(Uri.parse(super.clasesPath),
        headers: super.addToken(token), body: json.encode(clase.toJson()));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return newClase(clase);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> updateClase(Map<String, dynamic> body, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.put(Uri.parse(super.clasePath + "/" + id.toString()),
        headers: super.addToken(token), body: json.encode(body));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return updateClase(body, id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> deleteClase(Clase clase) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.delete(Uri.parse(super.clasePath + "/" + clase.id.toString()),
        headers: super.addToken(token));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return deleteClase(clase);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

}