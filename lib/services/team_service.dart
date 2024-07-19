import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/team.dart';
import 'package:app_dm/utils/constants.dart';
import './auth_service.dart';

class TeamService {
  final AuthService _authService = AuthService();

  Future<List<Team>> fetchTeams() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.get(
        Uri.parse('$apiBaseUrl/teams'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((team) => Team.fromJson(team)).toList();
      } else {
        throw Exception('Falha ao carregar equipes');
      }
    } catch (e) {
      throw Exception('Falha ao carregar equipes: $e');
    }
  }

  Future<void> createTeam(Team team) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final teamData = {
        'name': team.name,
        'members': team.members
            .map((member) => {
                  'id': member.id,
                  'username': member.username,
                })
            .toList(),
      };

      final response = await http.post(
        Uri.parse('$apiBaseUrl/teams'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(teamData),
      );

      if (response.statusCode != 201) {
        throw Exception('Falha ao criar equipe');
      }
    } catch (e) {
      throw Exception('Erro ao criar equipe: $e');
    }
  }

  Future<void> updateTeam(Team team) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final teamData = {
        'name': team.name,
        'members': team.members
            .map((member) => {
                  'id': member.id,
                  'username': member.username,
                })
            .toList(),
      };

      final response = await http.put(
        Uri.parse('$apiBaseUrl/teams/${team.id}'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(teamData),
      );

      if (response.statusCode != 200) {
        throw Exception('Falha ao atualizar equipe');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar equipe: $e');
    }
  }

  Future<void> deleteTeam(String teamId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.delete(
        Uri.parse('$apiBaseUrl/teams/$teamId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar equipe: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar equipe: $e');
    }
  }

  Future<void> removeMemberFromTeam(String teamId, String userId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final response = await http.delete(
        Uri.parse('$apiBaseUrl/teams/$teamId/members/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar equipe: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar equipe: $e');
    }
  }

  Future<void> addMemberToTeam(String teamId, String userId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final url = Uri.parse('$apiBaseUrl/teams/$teamId/members/$userId');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': userId,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Falha ao adicionar membro à equipe: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao adicionar membro à equipe: $e');
    }
  }
}
