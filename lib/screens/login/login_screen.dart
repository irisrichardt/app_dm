import 'package:flutter/material.dart';
import 'package:app_dm/services/auth_service.dart';
import 'package:app_dm/screens/HomeScreen.dart';
import 'package:app_dm/utils/constants.dart';

class LoginFormScreen extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      try {
        final response = await _apiService.login(username, password);
        print('Login successful: $response');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(token: response['token']),
          ),
        );
      } catch (e) {
        print('Login failed: $e');
        // Mostrar uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao fazer login: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Fundo branco
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: customBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Bem vindo(a) de volta! Faça login para continuar.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 90.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle, color: customBlue),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: customBlue),
                      ),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: customBlue),
                      hintText: 'Entre com o seu username',
                      hintStyle: TextStyle(color: customBlue.withOpacity(0.5)),
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
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_rounded, color: customBlue),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: customBlue),
                      ),
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: customBlue),
                      hintText: 'Entre com a sua senha',
                      hintStyle: TextStyle(color: customBlue.withOpacity(0.5)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          print('clicou no esqueceu senha');
                        },
                        child: const Text(
                          'Esqueceu a senha?',
                          style: TextStyle(color: customBlue, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _login,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(customBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(5),
                    ),
                    child: Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
