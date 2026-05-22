import 'package:flutter/material.dart';
import 'package:geo_tasks/app/theme/app_colors.dart';
import 'package:geo_tasks/features/tasks/models/task.dart';
import 'package:geo_tasks/features/tasks/viewmodels/task_form_view_model.dart';
import 'package:geo_tasks/features/tasks/viewmodels/add_edit_task_args.dart';
import 'package:geo_tasks/features/tasks/widgets/custom_text_field.dart';

class AddEditTaskPage extends StatefulWidget {
  const AddEditTaskPage({super.key});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final TaskFormViewModel _formViewModel = TaskFormViewModel();

  @override
  void dispose() {
    _formViewModel.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as AddEditTaskArgs?;
    final existingTask = args?.task;
    _formViewModel.initialize(existingTask);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          args?.isEditing == true ? 'Editar Tarefa' : 'Adicionar Tarefa',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFECF8F4), Color(0xFFF9FCFB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: AppColors.onPrimary,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: 'Nome da Tarefa',
                    hintText: 'Ex: Buscar encomenda no correio',
                    controller: _formViewModel.titleController,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Data',
                          hintText: 'dd/mm/aaaa',
                          controller: _formViewModel.dateController,
                          icon: Icons.calendar_today_outlined,
                          readOnly: true,
                          onTap: () => _formViewModel.pickDate(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'Horario',
                          hintText: '--:--',
                          controller: _formViewModel.timeController,
                          icon: Icons.access_time_outlined,
                          readOnly: true,
                          onTap: () => _formViewModel.pickTime(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Geolocalizacao',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 106,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9EDE7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF94D7CC),
                        width: 1.2,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () async {
                        final error = await _formViewModel.searchLocation();
                        if (!mounted) return;
                        if (error != null) {
                          _showMessage(error);
                          return;
                        }
                        _showMessage('Localizacao capturada com sucesso.');
                      },

                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.my_location_rounded,
                            color: AppColors.tertiary,
                            size: 34,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'CAPTURAR LOCALIZACAO (GPS)',
                            style: TextStyle(
                              color: AppColors.tertiary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'A tarefa sera ativada automaticamente quando voce\nentrar no perimetro.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _formViewModel.locationController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Nome do local (ex: Casa, Trabalho, Academia)',
                      hintStyle: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final error = _formViewModel.validate();
                        if (error != null) {
                          _showMessage(error);
                          return;
                        }

                        if (args == null) {
                          _showMessage('Nao foi possivel salvar a tarefa.');
                          return;
                        }

                        final Task task = _formViewModel.buildTask(
                          existingTask: existingTask,
                        );

                        if (args.isEditing) {
                          args.tasksViewModel.updateTask(args.taskIndex!, task);
                        } else {
                          args.tasksViewModel.addTask(task);
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Salvar Tarefa',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
