import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_dm/models/user.dart';
import 'package:app_dm/utils/constants.dart';

class UserService {
  Future<Usuario> createUser(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao criar o usuário: ${response.statusCode}');
    }
  }
}
