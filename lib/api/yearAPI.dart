import 'dart:convert';
import 'package:atopa_app_flutter/api/models/year.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'baseAPI.dart';

class YearAPI extends BaseAPI {


  Future<List<Year>> getYears() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.get(Uri.parse(super.yearsPath),
        headers: super.addToken(token));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['years'];
      List<Year> list = jsonResponse.map((data) => new Year.fromJson(data)).toList();
      return list;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getYears();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

}