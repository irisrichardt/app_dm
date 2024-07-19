import 'package:app_dm/models/team.dart';
import 'package:app_dm/services/team_service.dart';

class TeamRepository {
  final TeamService teamService;

  TeamRepository({required this.teamService});

  Future<List<Team>> fetchTeams() async {
    return await teamService.fetchTeams();
  }

  Future<void> createTeam(Team team) async {
    return await teamService.createTeam(team);
  }

  Future<void> updateTeam(Team team) async {
    await teamService.updateTeam(team);
  }

  Future<void> deleteTeam(String teamId) async {
    return await teamService.deleteTeam(teamId);
  }

  Future<void> removeMemberFromTeam(String teamId, String userId) async {
    await teamService.removeMemberFromTeam(teamId, userId);
  }

  Future<void> addMemberToTeam(String teamId, String userId) async {
    await teamService.addMemberToTeam(teamId, userId);
  }
}
