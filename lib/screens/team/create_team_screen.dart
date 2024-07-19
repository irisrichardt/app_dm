import 'package:flutter/material.dart';
import '../../services/team_service.dart';
import '../../models/team.dart';
import 'package:app_dm/utils/constants.dart';

class CreateTeamScreen extends StatefulWidget {
  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _teamName;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _teamName = '';
  }

  Future<void> _createTeam() async {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();

      try {
        final teamService = TeamService();
        await teamService.createTeam(
          Team(
            id: '',
            name: _teamName,
            members: [],
          ),
        );

        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Equipe criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        setState(() {
          _errorMessage = 'Erro ao criar a equipe: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Criar nova equipe",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: customBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                onPressed: _createTeam,
                child: Text(
                  'Criar',
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
