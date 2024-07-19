import 'package:flutter/material.dart';
import '../../services/team_service.dart';
import '../../models/team.dart';
import 'package:app_dm/utils/constants.dart';

class EditTeamScreen extends StatefulWidget {
  final Team team;

  EditTeamScreen({required this.team});

  @override
  _EditTeamScreenState createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends State<EditTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _teamName;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _teamName = widget.team.name;
  }

  Future<void> _updateTeam() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus(); // Fecha o teclado

      try {
        final teamService = TeamService();
        await teamService.updateTeam(
          Team(
            id: widget.team.id,
            name: _teamName,
            members: widget.team.members,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Equipe atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        setState(() {
          _errorMessage = 'Erro ao atualizar a equipe: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar equipe",
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _teamName,
                decoration: inputDecoration(
                  labelText: 'Nome da equipe',
                  hintText: 'Insira o nome',
                  icon: Icons.supervised_user_circle_sharp,
                ),
                onChanged: (value) {
                  setState(() {
                    _teamName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome de equipe.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: _updateTeam,
                child: Text(
                  'Atualizar',
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
      ),
    );
  }
}
