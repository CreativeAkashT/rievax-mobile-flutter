import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart' as constants;

class CustomHttpClient {
  static const String baseUrl = constants.apiBaseUrl;
  static String? authToken = "";
  
  static void init(){
    authToken = constants.user?.token;
  }

  static Future<http.Response> post(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };

    final String jsonBody = jsonEncode(body);

    final http.Response response =
        await http.post(uri, headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['success'] == true) {
        return response;
      } else {
        throw responseData['message'];
      }
    } else {
      throw 'Request failed with status: ${response.statusCode}';
    }
  }

  static Future<http.Response> get(String path) async {
    final Uri uri = Uri.parse('$baseUrl$path');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };

    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['success'] == true) {
        return response;
      } else {
        throw responseData['message'];
      }
    } else {
      throw 'Request failed with status: ${response.statusCode}';
    }
  }
}
