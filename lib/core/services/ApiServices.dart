import 'dart:convert';
import 'dart:typed_data';
import 'package:docs_for_employees/core/entities/UserEntity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../entities/DocumentEntity.dart';
import 'HashServise.dart';

class ApiServices{
  static const String _baseUrl = "http://localhost:8080";

  static Future<int> login(String number, String? password) async {
    Uri requestUrl = Uri.parse("$_baseUrl/login");

    Map<String, String> headers = {
      "Content-Type":"application/json"
    };

    Map<String, String> body = {
      "phoneNumber": HashService.getHash(number).toString()
    };

    if(password != null){
      body.addAll({"password": HashService.getHash(password).toString()});
    }

    final http.Response response = await http.post(
        requestUrl,
        headers: headers,
        body: jsonEncode(body)
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String token = jsonResponse['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("authorization", "Bearer $token");
    }

    return response.statusCode;
  }

  static Future<int?> addUserToSystem(String name, String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/addNewUser");

    Map<String, String> headers = {
      "Content-Type":"application/json",
      "authorization": token
    };

    Map<String, String> body = {
      "name": name,
      "phoneNumber": HashService.getHash(phoneNumber).toString(),
      "role": "USER",
    };

    final http.Response response = await http.post(
        requestUrl,
        headers: headers,
        body: jsonEncode(body)
    );

    return response.statusCode;
  }

  static Future<bool?> checkIfUserExist(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/checkIfUserExists");

    Map<String, String> headers = {
      "Content-Type":"application/json",
      "phone_number": HashService.getHash(phoneNumber).toString(),
      "authorization": token,
    };

    final http.Response response = await http.post(
        requestUrl,
        headers: headers,
    );

    if(response.statusCode == 200){
      return true;
    } else {
      return false;
    }
  }

  static Future<List<UserEntity>?> getAllUsersExceptMe() async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/getAllUsersExceptMe");
    Map<String, String> headers = {
      "Content-Type":"application/json",
      "Authorization": token,
    };

    final http.Response response = await http.get(
        requestUrl,
        headers: headers
    );

    if(response.statusCode == 201){
      List<UserEntity> users = List.empty(growable: true);
      List decodedResponse = json.decode(response.body);

      for (var element in decodedResponse) {
        users.add(UserEntity.fromJson(element));
      }

      return users;
    } else{
      return null;
    }
  }

  static Future<List<UserEntity>?> getUsersHaveAccessToFile(String fileId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/getUsersHaveAccessToFile");
    Map<String, String> headers = {
      "Content-Type":"application/json",
      "Authorization": token,
      "file_id": fileId
    };

    final http.Response response = await http.get(
        requestUrl,
        headers: headers
    );

    if(response.statusCode == 201){
      List<UserEntity> users = List.empty(growable: true);
      List decodedResponse = json.decode(response.body);

      for (var element in decodedResponse) {
        users.add(UserEntity.fromJson(element));
      }

      return users;
    } else{
      return null;
    }
  }

  static Future<List<UserEntity>?> getUsersDoNotHaveAccessToFile(String fileId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/getUsersDoNotHaveAccessToFile");
    Map<String, String> headers = {
      "Content-Type":"application/json",
      "Authorization": token,
      "file_id": fileId
    };

    final http.Response response = await http.get(
        requestUrl,
        headers: headers
    );

    if(response.statusCode == 201){
      List<UserEntity> users = List.empty(growable: true);
      List decodedResponse = json.decode(response.body);

      for (var element in decodedResponse) {
        users.add(UserEntity.fromJson(element));
      }

      return users;
    } else{
      return null;
    }
  }

  static Future<List<DocumentEntity>?> getFilesUserHaveAccess(String userId) async {
    print("================   $userId     =================");

    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/getFilesUserHaveAccess");
    Map<String, String> headers = {
      "Content-Type":"application/json",
      "Authorization": token,
      "user_id": userId
    };

    final http.Response response = await http.get(
        requestUrl,
        headers: headers
    );

    if(response.statusCode == 201){
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

  static Future<List<DocumentEntity>?> getAllAvailableFiles(bool read) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
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

  static Future<List<DocumentEntity>?> getAllFiles() async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/getAllFiles");
    Map<String, String> headers = {
      "Content-Type":"application/json",
      "Authorization": token,
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
    String? token  = prefs.getString("authorization");
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
    String? token  = prefs.getString("authorization");
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

  static Future<bool?> addAccessToFile(UserEntity user, DocumentEntity document) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/addAccess");
    Map<String, String> headers = {
      "Content-Type":"application/json",
      "Authorization": token,
    };

    Map<String, dynamic> body = {
      "userPhoneNumbers": [user.phoneNumber],
      "fileName": document.fileName
    };

    final http.Response response = await http.post(
        requestUrl,
        headers: headers,
        body: jsonEncode(body),
    );

    if(response.statusCode == 201){
      return true;
    }

    return false;
  }

  static Future<bool?> revokeAccessToFile(DocumentEntity document, UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/revokeAccessToFile");
    Map<String, String> headers = {
      "Content-Type":"application/json",
      "Authorization": token,
      "file_id": document.id.toString(),
      "user_id": user.id.toString(),
    };

    final http.Response response = await http.delete(
        requestUrl,
        headers: headers
    );

    if(response.statusCode == 201){
      return true;
    }

    return false;
  }

  static Future<bool?> postFile(String name, Uint8List bytes) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/postFile");
    Map<String, String> headers = {
      "Content-Type":"application/octet-stream",
      "Authorization": token,
      "file_name": name,
    };

    final http.Response response = await http.post(
        requestUrl,
        headers: headers,
        body: bytes
    );

    if(response.statusCode == 200){
      return true;
    }

    return false;
  }

  static Future<bool?> deleteFile(DocumentEntity document) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/deleteFile");
    Map<String, String> headers = {
      "Content-Type":"application/octet-stream",
      "Authorization": token,
      "file_id": document.id.toString(),
    };

    final http.Response response = await http.delete(
        requestUrl,
        headers: headers,
    );

    if(response.statusCode == 201){
      return true;
    }

    return false;
  }

  static Future<bool?> deleteUser(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    String? token  = prefs.getString("authorization");
    if(token == null){
      return null;
    }

    Uri requestUrl = Uri.parse("$_baseUrl/deleteUser");
    Map<String, String> headers = {
      "Content-Type":"application/octet-stream",
      "Authorization": token,
      "user_id": user.id.toString(),
    };

    final http.Response response = await http.delete(
      requestUrl,
      headers: headers,
    );

    if(response.statusCode == 201){
      return true;
    }

    return false;
  }
}