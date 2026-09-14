import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/task.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class ApiService {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Task>> getTasks() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/todos'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw ApiException('Server returned ${response.statusCode}, try again.');
      }

      final List data = jsonDecode(response.body);
      final List<Task> tasks = [];
      for (var item in data) {
        tasks.add(Task.fromJson(item));
      }
      return tasks;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Could not load tasks. Check your internet connection.');
    }
  }

  Future<Task> createTask(Task task) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/todos'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(task.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 201) {
        throw ApiException('Could not create task (${response.statusCode}).');
      }

      final Map<String, dynamic> json = jsonDecode(response.body);
      // JSONPlaceholder doesn't store description so we keep our own
      json['description'] = task.description;
      return Task.fromJson(json);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Could not create task. Try again.');
    }
  }

  Future<Task> updateTask(Task task) async {
    if (task.id == null) throw ApiException('Task id is missing.');

    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl/todos/${task.id}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(task.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('Could not update task (${response.statusCode}).');
      }

      final Map<String, dynamic> json = jsonDecode(response.body);
      json['description'] = task.description;
      return Task.fromJson(json);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Could not update task. Try again.');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseUrl/todos/$id'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException('Could not delete task (${response.statusCode}).');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Could not delete task. Try again.');
    }
  }
}
