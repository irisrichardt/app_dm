import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_dm/models/usuario.dart';
import 'package:app_dm/utils/constants.dart';

class CrieSuaContaScreen extends StatefulWidget {
  final Function(Usuario) onSave;

  CrieSuaContaScreen({required this.onSave});

  @override
  _CrieSuaContaScreenState createState() => _CrieSuaContaScreenState();
}

class _CrieSuaContaScreenState extends State<CrieSuaContaScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedGender = 'male';

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

  InputDecoration _inputDecoration(
      {required String labelText,
      required String hintText,
      required IconData icon}) {
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

  void _createAccount() async {
    if (_formKey.currentState!.validate()) {
      // Construir o payload
      Map<String, dynamic> data = {
        "username": _usernameController.text,
        "password": _passwordController.text,
        "name": _nameController.text,
        "birthDate": _birthDateController.text,
        "gender": _selectedGender,
        "email": _emailController.text,
      };

      // Exibir os dados no console antes de enviar
      print('Dados enviados para o servidor:');
      print('Username: ${data["username"]}');
      print('Password: ${data["password"]}');
      print('Name: ${data["name"]}');
      print('Birth Date: ${data["birthDate"]}');
      print('Gender: ${data["gender"]}');
      print('Email: ${data["email"]}');

      // Enviar a requisição POST
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3001/users'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 201) {
          // Conta criada com sucesso
          print('Conta criada com sucesso!');
          // Extrair os dados do usuário do corpo da resposta
          Usuario usuario = Usuario.fromJson(jsonDecode(response.body));
          // Chamar a função onSave passando o usuário criado
          widget.onSave(usuario);
          // Voltar para a tela anterior
          Navigator.pop(context);
        } else {
          // Falha ao criar a conta
          print('Falha ao criar a conta: ${response.statusCode}');
          // Mostrar uma mensagem de erro adequada para o usuário
        }
      } catch (e) {
        // Erro ao conectar com o servidor
        print('Erro ao conectar com o servidor: $e');
        // Mostrar uma mensagem de erro para o usuário
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
                onPressed: _createAccount,
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
