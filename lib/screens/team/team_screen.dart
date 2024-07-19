import 'package:flutter/material.dart';
import '../../services/team_service.dart';
import '../../models/team.dart';
import 'package:app_dm/utils/constants.dart';
import 'package:app_dm/repositories/team_repository.dart';
import 'team_details_screen.dart';
import 'edit_team_screen.dart';
import 'create_team_screen.dart'; // Importe a tela de criação de equipe

class TeamsScreen extends StatefulWidget {
  @override
  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  late TeamRepository _teamRepository;
  List<Team> _teams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _teamRepository = TeamRepository(teamService: TeamService());
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final teams = await _teamRepository.fetchTeams();
      print('Equipes carregadas: $teams'); // Adicione esta linha para depuração
      setState(() {
        _teams = teams;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar equipes: $e')),
      );
    }
  }

  void _editTeam(Team team) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTeamScreen(team: team),
      ),
    );
    if (result == true) {
      _loadTeams(); // Atualiza a lista de equipes após a edição
    }
  }

  Future<void> _deleteTeam(Team team) async {
    try {
      await _teamRepository.deleteTeam(team.id);
      setState(() {
        _teams.remove(team);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir equipe: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de equipes",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: customBlue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _teams.isEmpty
              ? Center(child: Text('Nenhuma equipe encontrada'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemCount: _teams.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      final team = _teams[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TeamDetailsScreen(team: team),
                            ),
                          ).then((result) {
                            if (result == true) {
                              _loadTeams();
                            }
                          });
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        team.name,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        '${team.members.length} membros',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _editTeam(_teams[index]);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteTeam(_teams[index]);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTeamScreen()),
          );
          if (result == true) {
            _loadTeams(); // Atualiza a lista de equipes após a criação
          }
        },
        backgroundColor: customBlue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
