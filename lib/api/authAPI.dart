import 'dart:convert';
import 'package:atopa_app_flutter/api/models/preferencias.dart';
import 'package:atopa_app_flutter/api/models/user.dart';
import 'package:http/http.dart'
as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'baseAPI.dart';

class AuthAPI extends BaseAPI {

  Future < http.Response > signUp(User user) async {
    http.Response response =
      await http.post(Uri.parse(super.signUpPath), headers: super.headers, body: json.encode(user.toJson()));
    return response;
  }

  Future < http.Response > login(String username, String password) async {
    var body = jsonEncode({
      'username': username,
      'password': password
    });

    http.Response response =
      await http.post(Uri.parse(super.loginPath), headers: super.headers, body: body);

    return response;
  }


  Future < http.Response > logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.post(Uri.parse(super.logoutPath),
      headers: super.addToken(token));
    await prefs.remove('jwt');
    await prefs.remove('jwt-refresh');
    return response;
  }

  Future < bool > checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.get(Uri.parse(super.loggedPath),
      headers: super.addToken(token));
    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));
      prefs.setInt('rol', user.rol!);
      prefs.setInt('evaluacion', user.evaluacion);
      return true;
    } else {
      return false;
    }


  }

  Future < User > getLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.get(Uri.parse(super.loggedPath),
      headers: super.addToken(token));
    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body));
      prefs.setInt('rol', user.rol!);
      prefs.setInt('evaluacion', user.evaluacion);
      return user;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getLoggedIn();
    } else {
      throw Exception('Unexpected error occured!');
    }


  }

  Future<http.Response> updateProfesor(Map<String, dynamic> body, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.put(Uri.parse(super.teacherPath + "/" + id.toString()),
        headers: super.addToken(token), body: json.encode(body));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return updateProfesor(body, id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> updatePreferencias(Map<String, dynamic> body, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.put(Uri.parse(super.preferencias + "/" + id.toString()),
        headers: super.addToken(token), body: json.encode(body));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return updatePreferencias(body, id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<Preferencias> getPreferencias(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.get(Uri.parse(super.preferenciasUser + "/" + id.toString()),
        headers: super.addToken(token));
    if (response.statusCode < 401) {
      Preferencias pref = Preferencias.fromJson(jsonDecode(response.body));
      return pref;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getPreferencias(id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

}