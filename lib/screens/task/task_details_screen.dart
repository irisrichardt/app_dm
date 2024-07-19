import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import 'package:app_dm/utils/constants.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    // Format the date for display
    String formattedDate = DateFormat('dd/MM/yyyy').format(task.expirationDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da atividade',
            style: TextStyle(color: Colors.white)),
        backgroundColor: customBlue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: customBlue,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.app_registration_outlined, color: customBlue),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    task.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.label_important, color: customBlue),
                SizedBox(width: 8.0),
                Text(
                  'Status: ${task.status}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.calendar_today, color: customBlue),
                SizedBox(width: 8.0),
                Text(
                  'Data de expiração: $formattedDate',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
