import 'dart:convert';
import 'package:atopa_app_flutter/api/models/test.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseAPI.dart';

class TestAPI extends BaseAPI {


  Future<List<Test>> getTests(int lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.get(Uri.parse(super.testsPath + "?idioma=" + lang.toString()),
        headers: super.addToken(token));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['tests'];
      List<Test> list = jsonResponse.map((data) => new Test.fromJson(data)).toList();
      return list;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getTests(lang);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<Test> getTest(int lang, Test test) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.get(Uri.parse(super.testPath + "/" + test.id.toString() + "?idioma=" + lang.toString()),
        headers: super.addToken(token));

    if (response.statusCode == 200) {
      Test list = new Test.fromJson(json.decode(response.body));
      return list;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getTest(lang, test);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Test>> getTestsSearch(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.post(Uri.parse(super.testsSearchPath),
        headers: super.addToken(token), body: json.encode(body));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['tests'];
      List<Test> list = jsonResponse.map((data) => new Test.fromJson(data)).toList();
      return list;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getTestsSearch(body);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future downloadCodes(Test test, int lang) async {
    try {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = await prefs.getString('jwt') ?? '';

        var dio = Dio();
        Response response = await dio.post(
          super.codes,
          data: {'test': test.id, 'idioma': lang},
        // onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            headers: super.addToken(token),
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
        );
        if (response.statusCode! < 401) {
          return response;
        } else if(response.statusCode == 401) {
          String token = await prefs.getString('jwt-refresh') ?? '';
          final response = await http.post(Uri.parse(super.refresh), 
          headers: super.addToken(token));
          token = jsonDecode(response.body)['token'];
          await prefs.setString('jwt', token);
          return downloadCodes(test, lang);
        } else {
          throw Exception('Unexpected error occured!');
        }
        
      
    } catch (e) {
      print(e);
    }
  }

  Future downloadAllPdf(Test test, int lang) async {
    try {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = await prefs.getString('jwt') ?? '';

        var dio = Dio();
        Response response = await dio.post(
          super.allPdf,
          data: {'test': test.id, 'idioma': lang},
        // onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            headers: super.addToken(token),
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
        );
        if (response.statusCode! < 401) {
          return response;
        } else if(response.statusCode == 401) {
          String token = await prefs.getString('jwt-refresh') ?? '';
          final response = await http.post(Uri.parse(super.refresh), 
          headers: super.addToken(token));
          token = jsonDecode(response.body)['token'];
          await prefs.setString('jwt', token);
          return downloadAllPdf(test, lang);
        } else {
          throw Exception('Unexpected error occured!');
        }
    } catch (e) {
      print(e);
    }
  }

  Future downloadTestPdf(Test test, int lang) async {
    try {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = await prefs.getString('jwt') ?? '';

        var dio = Dio();
        Response response = await dio.post(
          super.testPdf,
          data: {'test': test.id, 'idioma': lang},
        // onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            headers: super.addToken(token),
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
        );
        if (response.statusCode! < 401) {
          return response;
        } else if(response.statusCode == 401) {
          String token = await prefs.getString('jwt-refresh') ?? '';
          final response = await http.post(Uri.parse(super.refresh), 
          headers: super.addToken(token));
          token = jsonDecode(response.body)['token'];
          await prefs.setString('jwt', token);
          return downloadTestPdf(test, lang);
        } else {
          throw Exception('Unexpected error occured!');
        }
      
    } catch (e) {
      print(e);
    }
  }

  Future downloadStudentPdf(String alumno, Test test, int lang) async {
    try {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = await prefs.getString('jwt') ?? '';

        var dio = Dio();
        Response response = await dio.post(
          super.studentPdf,
          data: {'test': test.id, 'idioma': lang, "alumno": alumno},
        // onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            headers: super.addToken(token),
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
        );
        if (response.statusCode! < 401) {
          return response;
        } else if(response.statusCode == 401) {
          String token = await prefs.getString('jwt-refresh') ?? '';
          final response = await http.post(Uri.parse(super.refresh), 
          headers: super.addToken(token));
          token = jsonDecode(response.body)['token'];
          await prefs.setString('jwt', token);
          return downloadTestPdf(test, lang);
        } else {
          throw Exception('Unexpected error occured!');
        }
      
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response> followUp(Test test) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.post(Uri.parse(super.followUpPath),
        headers: super.addToken(token), body: json.encode({'test': test.id}));
    if (response.statusCode == 200) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return openTest(test);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> openTest(Test test) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.post(Uri.parse(super.openTestPath),
        headers: super.addToken(token), body: json.encode({'test': test.id}));
    if (response.statusCode == 200) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return openTest(test);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> closeTest(Test test) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.post(Uri.parse(super.closeTestPath),
        headers: super.addToken(token), body: json.encode({'test': test.id}));
    if (response.statusCode == 200) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return openTest(test);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> newTest(Test test) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.post(Uri.parse(super.testsPath),
        headers: super.addToken(token), body: json.encode(test.toJson()));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return newTest(test);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> checkAnswers(Test test) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.get(Uri.parse(super.checkResults + "/" + test.id.toString()),
        headers: super.addToken(token));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return newTest(test);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> updateTest(Map<String, dynamic> body, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.put(Uri.parse(super.testPath + "/" + id.toString()),
        headers: super.addToken(token), body: json.encode(body));

    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return updateTest(body, id);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<http.Response> deleteTest(Test test) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';

    http.Response response = await http.delete(Uri.parse(super.testPath + "/" + test.id.toString()),
        headers: super.addToken(token));
    if (response.statusCode < 401) {
      return response;
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return deleteTest(test);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<Map < String, dynamic >> getResults(int test, int lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.post(Uri.parse(super.resultsPath), body: json.encode({'idioma': lang, 'test': test}),
        headers: super.addToken(token));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getResults(test,lang);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<Map < String, dynamic >> getResultsComplete(int test, int lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.post(Uri.parse(super.informeTest), body: json.encode({'idioma': lang, 'test': test}),
        headers: super.addToken(token));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getResults(test,lang);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<Map < String, dynamic >> getResultsStudent(int test, int lang, String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('jwt') ?? '';
    http.Response response = await http.post(Uri.parse(super.informeStudent), body: json.encode({'idioma': lang, 'test': test, 'alumno': code}),
        headers: super.addToken(token));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if(response.statusCode == 401) {
      String token = await prefs.getString('jwt-refresh') ?? '';
      final response = await http.post(Uri.parse(super.refresh), 
      headers: super.addToken(token));
      token = jsonDecode(response.body)['token'];
      await prefs.setString('jwt', token);
      return getResults(test,lang);
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

}