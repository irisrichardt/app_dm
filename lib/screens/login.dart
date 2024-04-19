import 'package:app_dm/models/aluno.dart';
import 'package:app_dm/screens/crie_sua_conta.dart';
import 'package:app_dm/screens/home.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final _formKey =
      GlobalKey<FormState>(); // Defina a chave global para o formulário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            // Envolve os campos de texto com um Form e atribui a chave global
            key: _formKey, // Atribui a chave global ao Form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/images/img_2.png'),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Informe seus dados:',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Entre com email válido. Ex: abc@mail.com',
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Digite um email válido!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                    hintText: 'Entre com a sua senha',
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
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (valor) => const Home(),
                          ));
                    }
                    // Implementar a lógica de autenticação aqui
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                  ),
                  child: Text(
                    'Entrar',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(height: 120.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CrieSuaContaPage(
                              onSave: (Aluno aluno) {
                                // Implemente aqui o que você deseja fazer com os detalhes do aluno
                                // Por exemplo, enviar os detalhes do aluno para o servidor de autenticação
                                print(
                                    'Detalhes do aluno salvos: ${aluno.nome}, ${aluno.matricula}, ${aluno.email}, ${aluno.senha}');
                              },
                            ),
                          ),
                        );
                        print('clicou no crie sua conta');
                      },
                      child: const Text(
                        'Crie sua conta',
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
