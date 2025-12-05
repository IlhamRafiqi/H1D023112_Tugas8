import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tokokita/helpers/user_info.dart';
import 'app_exception.dart';

class Api {
  Future<dynamic> post(dynamic url, dynamic data) async {
    print('[Api] post() start');
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      print('[Api] POST $url');
      print('[Api] token=${token ?? "(no token)"}');
      print('[Api] body=$data');
      // Build headers conditionally: send Authorization only if token exists
      final headers = <String, String>{
        HttpHeaders.acceptHeader: "application/json",
      };
      if (token != null && token.isNotEmpty) {
        headers[HttpHeaders.authorizationHeader] = "Bearer $token";
      }

      // Set content-type based on payload type
      if (data is String) {
        headers[HttpHeaders.contentTypeHeader] = "application/json";
      } else {
        headers[HttpHeaders.contentTypeHeader] = "application/x-www-form-urlencoded";
      }

      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: headers
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('[Api] REQUEST TIMEOUT after 30 seconds');
          throw Exception('Connection timeout - Server tidak merespon');
        },
      );
      print('[Api] http status=${response.statusCode}');
      print('[Api] http body=${response.body}');
      responseJson = _returnResponse(response);
      print('[Api] responseJson returned successfully');
    } on SocketException catch (e) {
      print('[Api] SocketException: $e');
      throw FetchDataException('No Internet connection');
    } catch (e, st) {
      print('[Api] unknown error: $e');
      print(st);
      rethrow;
    }
    return responseJson;
  }

  Future<dynamic> get(dynamic url) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url),
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final response = await http.put(Uri.parse(url), body: data, headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json"
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(dynamic url) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final response = await http.delete(Uri.parse(url),
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
    case 201: // Created (common for POST/registrasi)
      var responseJson = response.body;
      return responseJson;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured with StatusCode : ${response.statusCode}');
  }
}