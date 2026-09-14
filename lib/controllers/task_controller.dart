import 'package:get/get.dart';

import '../models/task.dart';
import '../services/api_service.dart';

class TaskController extends GetxController {
  final _api = ApiService();

  var tasks = <Task>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs;
  var errorMessage = ''.obs;
  var searchText = ''.obs;
  var filter = TaskFilter.all.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  List<Task> get filteredTasks {
    var list = tasks.toList();

    // search filter
    if (searchText.value.trim().isNotEmpty) {
      list = list
          .where((t) => t.title
              .toLowerCase()
              .contains(searchText.value.trim().toLowerCase()))
          .toList();
    }

    // status filter
    if (filter.value == TaskFilter.completed) {
      list = list.where((t) => t.completed).toList();
    } else if (filter.value == TaskFilter.pending) {
      list = list.where((t) => !t.completed).toList();
    }

    return list;
  }

  Future<void> loadTasks({bool refresh = false}) async {
    if (!refresh) isLoading.value = true;
    errorMessage.value = '';

    try {
      final data = await _api.getTasks();
      tasks.assignAll(data);
    } catch (e) {
      if (e is ApiException) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = 'Something went wrong, try again.';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addTask({
    required String title,
    required String description,
    required bool completed,
  }) async {
    isSaving.value = true;

    try {
      final newTask = Task(
        title: title.trim(),
        description: description.trim(),
        completed: completed,
      );

      final created = await _api.createTask(newTask);
      tasks.insert(0, created);
      return true;
    } catch (e) {
      String msg = 'Could not add task.';
      if (e is ApiException) msg = e.message;
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> updateTask({
    required Task oldTask,
    required String title,
    required String description,
    required bool completed,
  }) async {
    isSaving.value = true;

    try {
      final updated = oldTask.copyWith(
        title: title.trim(),
        description: description.trim(),
        completed: completed,
      );

      await _api.updateTask(updated);

      final index = tasks.indexWhere((t) => t.id == oldTask.id);
      if (index != -1) {
        tasks[index] = updated;
      }

      return true;
    } catch (e) {
      String msg = 'Could not update task.';
      if (e is ApiException) msg = e.message;
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteTask(Task task) async {
    if (task.id == null) return;

    try {
      await _api.deleteTask(task.id!);
      tasks.removeWhere((t) => t.id == task.id);
      Get.snackbar('Deleted', 'Task removed.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      String msg = 'Could not delete task.';
      if (e is ApiException) msg = e.message;
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void setFilter(TaskFilter value) => filter.value = value;
  void setSearch(String value) => searchText.value = value;
}

enum TaskFilter { all, completed, pending }
