import 'dart:convert';

import 'package:todo_front/app/data/http/exceptions.dart';
import 'package:todo_front/app/data/http/http_client.dart';
import 'package:todo_front/app/data/models/task_model.dart';

abstract class ITaskRepository {
  Future<List<TaskModel>> getTasks();

  deleteTask(int id);

  createTask(TaskModel task);

  completeTask(int id) {}

  updateTask(TaskModel updatedTask) {}
}

class TaskRepository implements ITaskRepository {
  final IHttpClient client;

  TaskRepository({required this.client});

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await client.get(
      url: "http://127.0.0.1:8000/api/tasks",
    );

    if (response.statusCode == 200) {
      final List<TaskModel> tasks = [];

      final body = jsonDecode(response.body);

      body['tasks'].map((item) {
        final TaskModel task = TaskModel.fromMap(item);
        tasks.add(task);
      }).toList();

      return tasks;
    } else if (response.statusCode == 404) {
      throw NotFoundException("Url não encontrada");
    } else {
      throw Exception("Não foi possível carregar as tasks");
    }
  }

  Future<TaskModel> getTaskById(int id) async {
    final response = await client.get(
      url: "http://127.0.0.1:8000/api/tasks/$id",
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return TaskModel.fromMap(body['task']);
    } else if (response.statusCode == 404) {
      throw NotFoundException("Task não encontrada");
    } else {
      throw Exception("Erro ao carregar a tarefa");
    }
  }

  @override
  Future<void> createTask(TaskModel task) async {
    final response = await client.post(
      url: "http://127.0.0.1:8000/api/tasks",
      body: task.toMap(), // Aqui usamos o método toMap do TaskModel
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar a tarefa');
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final response = await client.put(
      url: "http://127.0.0.1:8000/api/tasks/${task.id}",
      body: task.toMap(),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar a tarefa');
    }
  }

  @override
  Future<void> completeTask(int id) async {
    final response = await client.put(
      url: "http://127.0.0.1:8000/api/tasks/complete/$id",
      body: {},
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao concluir a tarefa');
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    final response = await client.delete(
      url: "http://127.0.0.1:8000/api/tasks/$id",
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir a tarefa');
    }
  }
}
