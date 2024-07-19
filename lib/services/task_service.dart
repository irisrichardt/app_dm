import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import 'package:app_dm/utils/constants.dart';
import './auth_service.dart';

class TaskService {
  final AuthService _authService = AuthService();

  Future<List<Task>> fetchTasks() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse('$apiBaseUrl/task'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((task) => Task.fromJson(task)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }
}
