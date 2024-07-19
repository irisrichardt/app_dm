import 'package:app_dm/models/task.dart';
import 'package:app_dm/services/task_service.dart';

class TaskRepository {
  final TaskService taskService;

  TaskRepository({required this.taskService});

  Future<List<Task>> fetchTasks() async {
    return await taskService.fetchTasks();
  }

  Future<void> createTask(Task task) async {
    return await taskService.createTask(task);
  }

  Future<void> updateTask(Task task) async {
    await taskService.updateTask(task);
  }

  Future<void> deleteTask(String taskId) async {
    return await taskService.deleteTask(taskId);
  }
}
