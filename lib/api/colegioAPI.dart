import 'dart:convert';
import 'package:atopa_app_flutter/api/models/colegio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'baseAPI.dart';

class ColegioAPI extends BaseAPI {


  Future<List<Colegio>> getColegios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.get(Uri.parse(super.colegiosPath),
        headers: super.addToken(token));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['colegios'];
      List<Colegio> list = jsonResponse.map((data) => new Colegio.fromJson(data)).toList();
      return list;
    } else if (response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getColegios();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<Colegio> getColegio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.get(Uri.parse(super.colegioUserPath),
        headers: super.addToken(token));

    if (response.statusCode == 200) {
      Colegio colegio = new Colegio.fromJson(json.decode(response.body));
      return colegio;
    } else if (response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getColegio();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> newColegio(Colegio colegio) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.post(Uri.parse(super.colegiosPath),
        headers: super.addToken(token), body: json.encode(colegio.toJson()));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return newColegio(colegio);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> updateColegio(Map<String, dynamic> body, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.put(Uri.parse(super.colegioPath + "/" + id.toString()),
        headers: super.addToken(token), body: json.encode(body));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return updateColegio(body, id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> deleteColegio(Colegio colegio) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.delete(Uri.parse(super.colegioPath + "/" + colegio.id.toString()),
        headers: super.addToken(token));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return deleteColegio(colegio);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

}