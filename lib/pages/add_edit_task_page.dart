import 'package:flutter/material.dart';
import 'package:geo_tasks/core/controllers/task_form_controller.dart';
import 'package:geo_tasks/core/models/tasks.dart';
import 'package:geo_tasks/core/theme/app_colors.dart';
import 'package:geo_tasks/core/utils/task_formatters.dart';
import 'package:geo_tasks/widgets/custom_text_field.dart';

class AddEditTaskPage extends StatefulWidget {
  const AddEditTaskPage({super.key});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final TaskFormController _controller = TaskFormController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Recebe a tarefa dos arguments (se for editar)
    final task = ModalRoute.of(context)?.settings.arguments as Task?;

    if (task != null) {
      // Pré-preenche os campos
      _controller.titleController.text = task.title;
      _controller.dateController.text =
          '${task.date.day.toString().padLeft(2, '0')}/${task.date.month.toString().padLeft(2, '0')}/${task.date.year}';
      _controller.timeController.text = formatTaskTime(task.time);
      _controller.notesController.text = task.location ?? '';
      _controller.setSelectedDate(task.date);
      _controller.setSelectedTime(task.time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Adicionar Tarefa'),
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
                    controller: _controller.titleController,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Data',
                          hintText: 'dd/mm/aaaa',
                          controller: _controller.dateController,
                          icon: Icons.calendar_today_outlined,
                          readOnly: true,
                          onTap: () => _controller.pickDate(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'Horário',
                          hintText: '--:--',
                          controller: _controller.timeController,
                          icon: Icons.access_time_outlined,
                          readOnly: true,
                          onTap: () => _controller.pickTime(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Geolocalização',
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
                      onTap: () => _showMessage('Capture a localização aqui.'),
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
                            'CAPTURAR LOCALIZAÇÃO (GPS)',
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
                  Text(
                    'A tarefa será ativada automaticamente quando você\nentrar no perímetro.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _controller.notesController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Observações (opcional)',
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
                        final error = _controller.validate();
                        if (error != null) {
                          _showMessage(error);
                          return;
                        }

                        final existingTask =
                            ModalRoute.of(context)?.settings.arguments as Task?;
                        final task = _controller.buildTask(
                          existingTask: existingTask,
                        );
                        Navigator.pop(context, task);
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
