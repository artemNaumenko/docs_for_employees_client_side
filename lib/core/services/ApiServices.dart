import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../entities/DocumentEntity.dart';
import 'HashServise.dart';

class ApiServices{
  static const String _baseUrl = "http://localhost:8080";

  static Future<int> login(String number) async {
    Uri requestUrl = Uri.parse("$_baseUrl/login");

    Map<String, String> headers = {
      "Content-Type":"application/json"
    };

    Map<String, String> body = {
      "phoneNumber": HashService.getHash(number).toString()
    };

    final http.Response response = await http.post(
        requestUrl,
        headers: headers,
        body: jsonEncode(body)
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String token = jsonResponse['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", "Bearer $token");
      return response.statusCode;
    }

    return response.statusCode;
  }

  static Future<List<DocumentEntity>?> getAllAvailableFiles(bool read) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("token");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/getAllAvailableFiles");
    Map<String, String> headers = {
      "Content-Type":"application/json",
      "Authorization": token,
      "has_already_been_read": read.toString()
    };

    final http.Response response = await http.get(
        requestUrl,
        headers: headers
    );

    if(response.statusCode == 200){
      List<DocumentEntity> documents = List.empty(growable: true);
      List decodedResponse = json.decode(response.body);

      for (var element in decodedResponse) {
        documents.add(DocumentEntity.fromJson(element));
      }

      return documents;
    } else{
      return null;
    }
  }

  static Future<String?> getLinkOfFile(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("token");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/getLinkOfFile");
    Map<String, String> headers = {
      "Content-Type":"application/json",
      "Authorization": token,
      "file_name": fileName
    };

    final http.Response response = await http.get(
        requestUrl,
        headers: headers
    );

    if(response.statusCode == 200){
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String link = jsonResponse['link'];

      return link;
    }

    return "";
  }

  static Future<bool?> markFileAsRead(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("token");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/markAsRead");
    Map<String, String> headers = {
      "Content-Type":"application/json",
      "Authorization": token,
      "file_name": fileName
    };

    final http.Response response = await http.patch(
        requestUrl,
        headers: headers
    );

    if(response.statusCode == 202){
      return true;
    }

    return false;
  }

  // static postFile(String name, Uint8List bytes) async {
  //   Uri requestUrl = Uri.parse("$_baseUrl/postFile");
  //
  //   Map<String, String> headers = {
  //     "Content-Type":"application/octet-stream",
  //     "file_name": name
  //   };
  //
  //   final http.Response response = await http.post(
  //       requestUrl,
  //       headers: headers,
  //       body: bytes
  //   );
  //
  //   print(response.statusCode);
  //
  //   return;
  // }
}