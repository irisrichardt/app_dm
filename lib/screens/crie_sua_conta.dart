import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app_dm/models/aluno.dart';
import 'package:image_picker/image_picker.dart';

class CrieSuaContaPage extends StatefulWidget {
  final Function(Aluno) onSave;

  CrieSuaContaPage({required this.onSave});

  @override
  _CrieSuaContaPageState createState() => _CrieSuaContaPageState();
}

class _CrieSuaContaPageState extends State<CrieSuaContaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  File? _avatar;

  Future<void> _selecionarAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crie sua Conta',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_avatar != null)
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(_avatar!),
                        ),
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: _selecionarAvatar,
                  child: Text(
                    'Selecionar Avatar',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome',
                    hintText: 'Digite seu nome completo',
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
                  controller: _matriculaController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Matrícula',
                    hintText: 'Digite sua matrícula',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua matrícula!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Digite seu email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite um email válido!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua senha!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave(
                        Aluno(
                          nome: _nomeController.text,
                          matricula: int.parse(_matriculaController.text),
                          email: _emailController.text,
                          senha: _senhaController.text,
                          avatar: _avatar,
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                  ),
                  child: Text(
                    'Criar Conta',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
