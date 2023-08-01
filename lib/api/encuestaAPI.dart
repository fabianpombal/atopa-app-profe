import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'baseAPI.dart';

class EncuestaAPI extends BaseAPI {


  Future<http.Response> newEncuesta(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.post(Uri.parse(super.encuestasPath),
        headers: super.addToken(token), body: json.encode(body));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return newEncuesta(body);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> updateEncuesta(Map<String, dynamic> body, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.put(Uri.parse(super.encuestaPath + "/" + id.toString()),
        headers: super.addToken(token), body: json.encode(body));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return updateEncuesta(body, id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> deleteEncuesta(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.delete(Uri.parse(super.encuestaPath + "/" + id.toString()),
        headers: super.addToken(token));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return deleteEncuesta(id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

}