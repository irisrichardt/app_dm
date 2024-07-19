import 'package:flutter/material.dart';
import '../task_create_screen.dart';
import '../../services/task_service.dart';
import '../../models/task.dart';
import 'package:app_dm/utils/constants.dart';

class AtividadesScreen extends StatefulWidget {
  final String categoryName;

  const AtividadesScreen({required this.categoryName});

  @override
  _AtividadesScreenState createState() => _AtividadesScreenState();
}

class _AtividadesScreenState extends State<AtividadesScreen> {
  final TaskService _taskService = TaskService();
  late Future<List<Task>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _taskService.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de atividades",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: customBlue,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar atividades'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma atividade encontrada'));
          } else {
            List<Task> tasks = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(tasks[index].title),
                        subtitle: Text(tasks[index].description),
                        onTap: () {
                          print('Atividadeeeee ${tasks[index].title} clicada');
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CriarAtividadeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Nova Atividadeeeee'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
