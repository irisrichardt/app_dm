import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_dm/models/user.dart';
import 'package:app_dm/utils/constants.dart';
import './auth_service.dart';

class UserService {
  final AuthService _authService = AuthService();

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

  Future<List<Usuario>> fetchUsers() async {
    try {
      final token = await _authService.getToken();

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse('$apiBaseUrl/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        if (userData is List) {
          return userData.map((json) => Usuario.fromJson(json)).toList();
        } else {
          throw Exception('Dados dos usuários não são uma lista');
        }
      } else {
        throw Exception(
            'Erro ao buscar dados dos usuários: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar dados dos usuários: $e');
    }
  }
}
