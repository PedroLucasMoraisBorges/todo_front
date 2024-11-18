import 'package:flutter/material.dart';
import 'package:todo_front/app/data/http/exceptions.dart';
import 'package:todo_front/app/data/models/task_model.dart';
import 'package:todo_front/app/data/repositories/task_repository.dart';

class TaskStore {
  final ITaskRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<TaskModel>> state =
      ValueNotifier<List<TaskModel>>([]);

  final ValueNotifier<String> erro = ValueNotifier<String>("");

  TaskStore({required this.repository});

  Future getTasks() async {
    isLoading.value = true;

    try {
      final result = await repository.getTasks();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> createTask(TaskModel task) async {
    isLoading.value = true;
    try {
      await repository.createTask(task);
      state.value = [...state.value, task]; // Adicione a nova tarefa ao estado
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isLoading.value = false;
  }

  Future deleteTask(int id) async {
    isLoading.value = true;

    try {
      await repository.deleteTask(id);
      state.value.removeWhere((task) => task.id == id);
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> completeTask(int id) async {
    isLoading.value = true;
    try {
      await repository.completeTask(id);
      final index = state.value.indexWhere((task) => task.id == id);
      if (index != -1) {
        state.value[index] = state.value[index].copyWith(isComplete: true);
        state.value = [...state.value];
      }
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isLoading.value = false;
  }

  Future<void> updateTask(TaskModel updatedTask) async {
    isLoading.value = true;
    try {
      await repository.updateTask(updatedTask);
      final index = state.value.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        state.value[index] = updatedTask;
        state.value = [...state.value];
      }
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }
    isLoading.value = false;
  }
}
