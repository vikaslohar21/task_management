import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/task_controller.dart';
import '../widgets/filter_bar.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.loadTasks,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const TaskFormScreen()),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.tasks.isEmpty) {
            return _buildErrorView(controller);
          }

          return RefreshIndicator(
            onRefresh: () => controller.loadTasks(refresh: true),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildSearchAndFilter(controller)),
                if (controller.errorMessage.value.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ),
                _buildTaskList(controller, context),
                const SliverPadding(padding: EdgeInsets.only(bottom: 90)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchAndFilter(TaskController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          TextField(
            onChanged: controller.setSearch,
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: Obx(
                () => controller.searchText.value.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: () => controller.setSearch(''),
                        icon: const Icon(Icons.clear),
                      ),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => FilterBar(
              selected: controller.filter.value,
              onChanged: controller.setFilter,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(TaskController controller, BuildContext context) {
    return Obx(() {
      final items = controller.filteredTasks;

      if (items.isEmpty) {
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No tasks found.\nTry a different search or add a new task.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList.builder(
          itemCount: items.length,
          itemBuilder: (_, index) {
            final task = items[index];
            return TaskCard(
              task: task,
              onEdit: () => Get.to(() => TaskFormScreen(task: task)),
              onDelete: () => _showDeleteDialog(context, task, controller),
            );
          },
        ),
      );
    });
  }

  Widget _buildErrorView(TaskController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Could not load tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(controller.errorMessage.value, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: controller.loadTasks,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(
      BuildContext context, task, TaskController controller) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task?'),
        content: const Text('This will permanently remove the task.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.deleteTask(task);
    }
  }
}
