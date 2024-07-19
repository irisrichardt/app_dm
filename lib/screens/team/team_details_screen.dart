import 'package:flutter/material.dart';
import '../../models/team.dart';
import 'package:app_dm/utils/constants.dart';
import '../../repositories/team_repository.dart';
import '../../services/team_service.dart';
import 'add_member_screen.dart';

class TeamDetailsScreen extends StatefulWidget {
  final Team team;

  TeamDetailsScreen({required this.team});

  @override
  _TeamDetailsScreenState createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  late TeamRepository _teamRepository;

  @override
  void initState() {
    super.initState();
    _teamRepository = TeamRepository(teamService: TeamService());
  }

  Future<void> _removeMember(String teamId, String userId) async {
    try {
      await _teamRepository.removeMemberFromTeam(teamId, userId);
      setState(() {
        widget.team.members.removeWhere((member) => member.id == userId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Membro removido com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover membro: $e')),
      );
    }
  }

  void _showAddMemberDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMemberDialog(
          onMemberAdded: (user) async {
            try {
              await _teamRepository.addMemberToTeam(widget.team.id, user.id);
              setState(() {
                widget.team.members.add(user); // Atualiza a lista de membros
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Membro adicionado com sucesso!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao adicionar membro: $e')),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.team.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: customBlue,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Membros da equipe',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: widget.team.members.length,
                itemBuilder: (context, index) {
                  final member = widget.team.members[index];
                  return ListTile(
                    title: Text(member.username),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        _removeMember(widget.team.id, member.id);
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _showAddMemberDialog,
              child: Text(
                'Adicionar membro',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: customBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
