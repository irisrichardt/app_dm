import 'package:flutter/material.dart';
import 'task_create_screen.dart';
import '../../services/task_service.dart';
import '../../models/task.dart';
import 'task_details_screen.dart';
import 'package:app_dm/utils/constants.dart';
import 'package:app_dm/repositories/task_repository.dart';
import 'package:app_dm/screens/task/edit_task_screen.dart';

class AtividadesScreen extends StatefulWidget {
  final String categoryName;

  const AtividadesScreen({required this.categoryName});

  @override
  _AtividadesScreenState createState() => _AtividadesScreenState();
}

class _AtividadesScreenState extends State<AtividadesScreen> {
  late TaskRepository _taskRepository;
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _taskRepository =
        TaskRepository(taskService: TaskService()); // Inicialize o repositório
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true; // Começa a exibir o indicador de carregamento
    });
    try {
      final tasks = await _taskRepository.fetchTasks(); // Recupera as tarefas
      setState(() {
        _tasks = tasks; // Atualiza a lista de tarefas
        _isLoading = false; // Oculta o indicador de carregamento
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Oculta o indicador de carregamento
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar atividades: $e')),
      );
    }
  }

  void _editTask(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    );
    if (result == true) {
      _loadTasks(); // Atualiza a lista de tarefas após a edição
    }
  }

  Future<void> _deleteTask(Task task) async {
    try {
      await _taskRepository.deleteTask(task.id); // Use o repositório
      setState(() {
        _tasks.remove(task); // Remove a tarefa localmente
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir tarefa: $e')),
      );
    }
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? Center(child: Text('Nenhuma atividade encontrada'))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemCount: _tasks.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TaskDetailsScreen(task: _tasks[index]),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _tasks[index].title,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(_tasks[index].description),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _editTask(_tasks[index]);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteTask(_tasks[index]);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CriarAtividadeScreen()),
          );
          if (result == true) {
            _loadTasks(); // Atualiza a lista de tarefas
          }
        },
        backgroundColor: customBlue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
