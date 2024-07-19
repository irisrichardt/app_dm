import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import '../../repositories/user_repository.dart';

class AddMemberDialog extends StatefulWidget {
  final Function(Usuario) onMemberAdded;

  AddMemberDialog({required this.onMemberAdded});

  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  late Future<List<Usuario>> _usersFuture;
  Usuario? _selectedUser;
  String? _errorMessage; // Variável para armazenar mensagens de erro

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    final userRepository = UserRepository(userService: UserService());
    setState(() {
      _usersFuture = userRepository.getUsers(); // Atualiza o Future
    });
  }

  Future<void> _submit() async {
    if (_selectedUser != null) {
      try {
        // Adicione o membro aqui
        // Exemplo: await teamService.addMemberToTeam(teamId, _selectedUser!.id);

        widget.onMemberAdded(_selectedUser!);

        // Recarregue a lista de usuários
        _loadUsers();

        Navigator.of(context).pop(); // Fecha o diálogo
      } catch (e) {
        setState(() {
          _errorMessage = 'Erro ao adicionar o membro: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Adicionar Membro'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<List<Usuario>>(
            future: _usersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Ou um widget de carregamento
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar usuários');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Nenhum usuário disponível');
              }

              final users = snapshot.data!;
              return DropdownButtonFormField<Usuario>(
                value: _selectedUser,
                onChanged: (Usuario? newValue) {
                  setState(() {
                    _selectedUser = newValue;
                  });
                },
                items: users.map((Usuario user) {
                  return DropdownMenuItem<Usuario>(
                    value: user,
                    child: Text(user.username),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Selecione um usuário'),
              );
            },
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o diálogo
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: _submit,
          child: Text('Adicionar'),
        ),
      ],
    );
  }
}
