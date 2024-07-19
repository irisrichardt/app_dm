import 'package:flutter/material.dart';
import 'package:app_dm/screens/team/team_screen.dart';
import '../task/task_screen.dart';
import '../login/login_screen.dart';
import '../../services/user_service.dart';
import '../../services/task_service.dart';
import '../../utils/constants.dart';
import 'package:app_dm/models/user.dart';
import 'package:app_dm/models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  final TaskService _taskService = TaskService();

  late Future<Map<String, dynamic>> _dashboardData;

  @override
  void initState() {
    super.initState();
    _dashboardData = _fetchDashboardData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _dashboardData = _fetchDashboardData();
    });
  }

  Future<Map<String, dynamic>> _fetchDashboardData() async {
    final List<Usuario> usuarios = await _userService.fetchUsers();
    final List<Task> tasks = await _taskService.fetchTasks();

    final int totalUsers = usuarios.length;

    final Map<String, int> statusCounts = {
      'IN_PROGRESS': 0,
      'DONE': 0,
      'TO_DO': 0,
    };

    for (var task in tasks) {
      if (statusCounts.containsKey(task.status)) {
        statusCounts[task.status] = (statusCounts[task.status] ?? 0) + 1;
      }
    }

    return {
      'totalUsers': totalUsers,
      'statusCounts': statusCounts,
      'recentActivities': tasks.take(3).map((task) => '${task.title}').toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo!',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Resumo do seu dia',
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
                Scaffold.of(context).openDrawer();
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
                'WorkFlow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Atividades'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AtividadesScreen(
                          categoryName: 'Lista de atividades')),
                ).then((_) {
                  _refreshData();
                });
              },
            ),
            ListTile(
              title: Text('Gerenciar Equipes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeamsScreen()),
                ).then((_) {
                  // Quando você retorna para a HomeScreen, atualize os dados
                  _refreshData();
                });
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginFormScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dashboardData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              final statusCounts = data['statusCounts'] as Map<String, int>;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumo do Dia',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text('Total de usuários'),
                        trailing: Text(
                          '${data['totalUsers']}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Total de atividades',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          'Pendentes',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Text(
                          '${statusCounts['TO_DO']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          'Em andamento',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Text(
                          '${statusCounts['IN_PROGRESS']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          'Concluídas',
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Text(
                          '${statusCounts['DONE']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Atividades recentes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ...data['recentActivities'].map<Widget>(
                      (activity) => Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text(activity),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Nenhum dado disponível'));
            }
          },
        ),
      ),
    );
  }
}
