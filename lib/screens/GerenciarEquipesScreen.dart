import 'package:flutter/material.dart';

class GerenciarEquipesScreen extends StatefulWidget {
  @override
  _GerenciarEquipesScreenState createState() => _GerenciarEquipesScreenState();
}

class _GerenciarEquipesScreenState extends State<GerenciarEquipesScreen> {
  final List<Map<String, String>> _teamMembers = [
    {'name': 'Membro 1', 'team': 'Frontend'},
    {'name': 'Membro 2', 'team': 'Backend'},
    {'name': 'Membro 3', 'team': 'Infra'},
  ];

  final TextEditingController _memberController = TextEditingController();
  String? _selectedTeam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gerenciar Equipes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Selecione a Equipe',
                border: OutlineInputBorder(),
              ),
              value: _selectedTeam,
              items: ['Frontend', 'Backend', 'Infra']
                  .map((team) => DropdownMenuItem(
                        value: team,
                        child: Text(team),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTeam = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Por favor, selecione uma equipe';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _memberController,
              decoration: InputDecoration(
                labelText: 'Nome do Membro',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_memberController.text.isNotEmpty &&
                      _selectedTeam != null) {
                    _teamMembers.add({
                      'name': _memberController.text,
                      'team': _selectedTeam!,
                    });
                    _memberController.clear();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: Text('Adicionar Membro'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _teamMembers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_teamMembers[index]['name']!),
                      subtitle: Text('Equipe: ${_teamMembers[index]['team']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _teamMembers.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
