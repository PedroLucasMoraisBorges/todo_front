import 'package:flutter/material.dart';
import 'package:todo_front/app/data/models/task_model.dart';
import 'package:todo_front/app/data/repositories/task_repository.dart';
import 'package:todo_front/app/pages/home/task_store.dart';

class TaskPage extends StatefulWidget {
  final int taskId;
  final TaskStore store;

  const TaskPage({
    Key? key,
    required this.taskId,
    required this.store,
    required TaskRepository repository,
  }) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Future<TaskModel?> taskDetails;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isComplete = false;

  @override
  void initState() {
    super.initState();
    taskDetails = _loadTaskData();
  }

  Future<TaskModel?> _loadTaskData() async {
    try {
      final task = widget.store.state.value.firstWhere(
        (task) => task.id == widget.taskId,
        orElse: () => throw Exception('Tarefa não encontrada'),
      );
      titleController.text = task.title;
      descriptionController.text = task.description;
      isComplete = task.isComplete ?? false;
      return task;
    } catch (e) {
      widget.store.erro.value = e.toString();
      return null;
    }
  }

  Future<void> _updateTask() async {
    // Verifique se os campos estão preenchidos
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      // Exibe um alerta se algum campo estiver vazio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    final updatedTask = TaskModel(
      id: widget.taskId,
      title: titleController.text,
      description: descriptionController.text,
      isComplete: isComplete,
    );

    try {
      await widget.store.updateTask(updatedTask);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarefa atualizada com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar tarefa: $e')),
      );
    }
  }

  Future<void> _completeTask() async {
    // Verifique se os campos estão preenchidos antes de completar a tarefa
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      // Exibe um alerta se algum campo estiver vazio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    try {
      await widget.store.updateTask(TaskModel(
        id: widget.taskId,
        title: titleController.text,
        description: descriptionController.text,
        isComplete: true,
      ));
      setState(() {
        isComplete = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarefa concluída com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao concluir tarefa: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Tarefa'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<TaskModel?>(
        future: taskDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.data != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Status: ${isComplete ? "Concluída" : "Pendente"}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: isComplete ? null : _completeTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green, // Cor do botão para completar
                          foregroundColor:
                              Colors.white, // Cor do texto no botão
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 16.0),
                        ),
                        child: const Text(
                          'Concluir Tarefa',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _updateTask,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 16.0),
                        ),
                        child: const Text(
                          'Salvar Alterações',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Tarefa não encontrada.'));
        },
      ),
    );
  }
}
