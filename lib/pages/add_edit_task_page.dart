import 'package:flutter/material.dart';

class AddEditTaskPage extends StatelessWidget {
  const AddEditTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Tarefa'),
        centerTitle: true,
      ),
    );
  }
}
