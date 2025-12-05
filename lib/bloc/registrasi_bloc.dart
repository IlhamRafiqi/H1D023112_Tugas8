import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi({String? nama, String? email, String? password}) async {
    String apiUrl = ApiUrl.registrasi;

    // Kirim sebagai JSON agar cocok dengan banyak API Laravel modern
    var bodyMap = {"nama": nama, "email": email, "password": password};
    var jsonBody = jsonEncode(bodyMap);

    // Api().post mengembalikan String body, jadi langsung decode
    var response = await Api().post(apiUrl, jsonBody);
    var jsonObj = json.decode(response);
    return Registrasi.fromJson(jsonObj);
  }
}