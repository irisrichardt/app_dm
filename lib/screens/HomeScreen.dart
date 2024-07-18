import 'package:app_dm/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AtividadesScreen.dart';
import 'GerenciarEquipesScreen.dart';
import 'LoginFormScreen.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({required this.token, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Usuario> _usuarios = []; // Lista de usuários
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      var url = Uri.parse('http://10.0.2.2:3001/users');
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        if (userData is List) {
          setState(() {
            _usuarios = userData.map((json) => Usuario.fromJson(json)).toList();
            _isLoading = false;
          });
        } else {
          print('Dados dos usuários não são uma lista');
          setState(() => _isLoading = false);
        }
      } else {
        print('Erro ao buscar dados dos usuários: ${response.statusCode}');
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Erro ao buscar dados dos usuários: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atividades',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Suas atividades recentes',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Abre o menu lateral
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu Lateral',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu lateral
                // Navegue para a tela de Home
                // Aqui você pode adicionar código se quiser navegar de volta para a tela de Home
              },
            ),
            ListTile(
              title: Text('Atividades'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu lateral
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AtividadesScreen(
                          categoryName:
                              'Atividades Frontend')), // Navega para a tela de Atividades
                );
              },
            ),
            ListTile(
              title: Text('Gerenciar Equipes'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu lateral
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GerenciarEquipesScreen()), // Navega para a tela de Gerenciar Equipes
                );
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu lateral
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginFormScreen()), // Navega para a tela de Login
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Indicador de carregamento enquanto busca os dados
            : _usuarios.isNotEmpty
                ? ListView.builder(
                    itemCount: _usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = _usuarios[index];
                      return ListTile(
                        title: Text(usuario.name),
                        subtitle: Text(usuario.email),
                      );
                    },
                  )
                : Text(
                    'Nenhum usuário encontrado'), // Mensagem para quando a lista estiver vazia
      ),
    );
  }
}
