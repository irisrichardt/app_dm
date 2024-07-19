import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';
import '../../repositories/task_repository.dart';
import 'package:app_dm/utils/constants.dart';

enum TaskStatus { TO_DO, IN_PROGRESS, DONE }

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TaskRepository _taskRepository;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskStatus? _selectedStatus;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _taskRepository = TaskRepository(taskService: TaskService());

    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
    _selectedStatus = _stringToTaskStatus(widget.task.status);
    _selectedDate = widget.task.expirationDate;
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar Atividade",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: customBlue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration(
                  labelText: 'Título',
                  hintText: 'Insira o título',
                  icon: Icons.title,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0), // Increase space between fields
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Insira a descrição',
                  icon: Icons.app_registration_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0), // Increase space between fields
              DropdownButtonFormField<TaskStatus>(
                value: _selectedStatus,
                decoration: _inputDecoration(
                  labelText: 'Status',
                  hintText: 'Selecione o status',
                  icon: Icons.label_important,
                ),
                items: TaskStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_translateStatus(status)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione um status';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0), // Increase space between fields
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    readOnly: true,
                    decoration: _inputDecoration(
                      labelText: 'Data de expiração',
                      hintText: 'Selecione a data de expiração',
                      icon: Icons.calendar_today,
                    ),
                    controller: TextEditingController(
                      text: _selectedDate == null
                          ? ''
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    ),
                    validator: (value) {
                      if (_selectedDate == null) {
                        return 'Por favor, selecione uma data de expiração';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 24.0), // Increase space between fields
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _selectedDate != null &&
                      _selectedStatus != null) {
                    _updateTask(); // Call method to update task
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Por favor, preencha todos os campos'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Atualizar atividade',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateTask() async {
    if (_formKey.currentState!.validate()) {
      Task updatedTask = Task(
        id: widget.task.id,
        title: _titleController.text,
        description: _descriptionController.text,
        status: _selectedStatus.toString().split('.').last,
        expirationDate: _selectedDate!,
      );

      try {
        await _taskRepository.updateTask(updatedTask);
        print('Atividade atualizada com sucesso!');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Atividade atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } catch (e) {
        print('Erro ao conectar com o servidor: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar atividade. Tente novamente!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _translateStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.TO_DO:
        return 'Pendente';
      case TaskStatus.IN_PROGRESS:
        return 'Em Andamento';
      case TaskStatus.DONE:
        return 'Concluído';
      default:
        return '';
    }
  }

  TaskStatus _stringToTaskStatus(String status) {
    switch (status) {
      case 'Pendente':
        return TaskStatus.TO_DO;
      case 'Em Andamento':
        return TaskStatus.IN_PROGRESS;
      case 'Concluído':
        return TaskStatus.DONE;
      default:
        return TaskStatus.TO_DO;
    }
  }
}
