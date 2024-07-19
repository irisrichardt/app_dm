import 'package:flutter/material.dart';
import 'package:app_dm/models/user.dart';
import 'package:app_dm/utils/constants.dart';
import 'package:app_dm/services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  final Function(Usuario) onSave;

  RegisterScreen({required this.onSave});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedGender = 'male';
  final UserService _userService = UserService();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: customBlue),
      filled: true,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: customBlue),
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: customBlue),
      hintText: hintText,
      hintStyle: TextStyle(color: customBlue.withOpacity(0.5)),
    );
  }

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      // Criar o Map com os dados do usuário
      Map<String, dynamic> userData = {
        'username': _usernameController.text,
        'password': _passwordController.text,
        'name': _nameController.text,
        'birthDate': _birthDateController.text,
        'gender': _selectedGender,
        'email': _emailController.text,
      };

      try {
        // Passar o Map para o método createUser
        Usuario newUsuario = await _userService.createUser(userData);
        print('Conta criada com sucesso!');

        // Exibir SnackBar de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        widget.onSave(newUsuario);
        Navigator.pop(context);
      } catch (e) {
        print('Erro ao conectar com o servidor: $e');

        // Exibir SnackBar de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar conta. Tente novamente!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crie sua conta', style: TextStyle(color: Colors.white)),
        backgroundColor: customBlue,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: _inputDecoration(
                  labelText: 'Username',
                  hintText: 'Entre com o seu username',
                  icon: Icons.account_circle,
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Digite um usermame válido!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration(
                  labelText: 'Senha',
                  hintText: 'Digite sua senha',
                  icon: Icons.lock,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite sua senha!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration(
                  labelText: 'Nome',
                  hintText: 'Digite seu nome completo',
                  icon: Icons.person,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu nome completo!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _birthDateController,
                decoration: _inputDecoration(
                  labelText: 'Data de Nascimento',
                  hintText: 'Digite sua data de nascimento (AAAA-MM-DD)',
                  icon: Icons.calendar_today,
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite sua data de nascimento!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: _inputDecoration(
                  labelText: 'Gênero',
                  hintText: 'Selecione seu gênero',
                  icon: Icons.person_outline,
                ),
                style: TextStyle(color: customBlue),
                items: ['male', 'female', 'other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione seu gênero!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration(
                  labelText: 'Email',
                  hintText: 'Digite seu email',
                  icon: Icons.email,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite um email válido!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _createUser,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(customBlue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(5),
                ),
                child: Text(
                  'Criar conta',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
