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

  Future<void> createTask(Task task) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final taskData = {
        'title': task.title,
        'description': task.description,
        'status': task.status,
        'expirationDate': task.expirationDate.toIso8601String(),
      };

      print('Creating task at $apiBaseUrl/task');
      print(
          'Headers: {Authorization: Bearer $token, Content-Type: application/json; charset=UTF-8}');
      print('Body: ${jsonEncode(taskData)}');

      final response = await http.post(
        Uri.parse('$apiBaseUrl/task'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(taskData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 201) {
        throw Exception('Failed to create task');
      }
    } catch (e) {
      print('Erro ao criar a tarefa: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('Token não encontrado');
    }

    final response = await http.delete(
      Uri.parse('$apiBaseUrl/task/$taskId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar a tarefa: ${response.statusCode}');
    }
  }
}
