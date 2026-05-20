import 'package:flutter/material.dart';
import 'package:geo_tasks/widgets/task_card.dart';
import 'package:geo_tasks/core/models/tasks.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [];

  Future<void> _openAddTask() async {
    final result = await Navigator.of(context).pushNamed('/AddEditTasks');

    if (result is Task) {
      setState(() {
        _tasks.add(result);
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _completeTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _editTask(int index) async {
    final task = _tasks[index];
    final result = await Navigator.of(context).pushNamed(
      '/AddEditTasks',
      arguments: task,
    );

    if (result is Task) {
      setState(() {
        _tasks[index] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 110,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
        ),
        titleSpacing: 20,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Olá, usuário 👋',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B7267),
                height: 1.1,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Vamos organizar seu dia?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF58615F),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF17A89B),
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                backgroundColor: Color(0xFFDAF5F1),
                child: Icon(
                  Icons.person,
                  color: Color(0xFF0B7267),
                  size: 32,
                ),
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE5E8E7),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTask,
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          final dateStr =
              '${task.date.day.toString().padLeft(2, '0')}/${task.date.month.toString().padLeft(2, '0')}';
          final timeStr = task.time.format(context);
          final timeLabel = '$dateStr $timeStr';
          return TaskCard(
            title: task.title,
            time: timeLabel,
            location: task.location ?? 'Sem local',
            isCompleted: task.isCompleted,
            onDelete: () => _deleteTask(index),
            onComplete: () => _completeTask(index),
            onEdit: () => _editTask(index),
          );
        },
      ),
    );
  }
}
