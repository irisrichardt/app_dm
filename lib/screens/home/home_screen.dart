import 'package:app_dm/models/user.dart';
import 'package:flutter/material.dart';
import '../task/task_screen.dart';
import '../GerenciarEquipesScreen.dart';
import '../login/login_screen.dart';
import '../../services/user_service.dart';
import 'package:app_dm/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  late Future<List<Usuario>> _usuarios;

  @override
  void initState() {
    super.initState();
    _usuarios = _userService.fetchUsers();
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
              'Atividades recentes',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: customBlue,
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
                color: customBlue,
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
                              'Lista de atividades')), // Navega para a tela de Atividades
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
      body: FutureBuilder<List<Usuario>>(
        future: _usuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final usuarios = snapshot.data!;
            return usuarios.isNotEmpty
                ? ListView.builder(
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = usuarios[index];
                      return ListTile(
                        title: Text(usuario.name),
                        subtitle: Text(usuario.email),
                      );
                    },
                  )
                : Center(child: Text('Nenhum usuário encontrado'));
          } else {
            return Center(child: Text('Nenhum usuário encontrado'));
          }
        },
      ),
    );
  }
}
