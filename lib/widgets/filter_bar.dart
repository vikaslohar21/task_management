import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';

class FilterBar extends StatelessWidget {
  final TaskFilter selected;
  final ValueChanged<TaskFilter> onChanged;

  const FilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TaskFilter>(
      segments: const [
        ButtonSegment(value: TaskFilter.all, label: Text('All')),
        ButtonSegment(value: TaskFilter.completed, label: Text('Completed')),
        ButtonSegment(value: TaskFilter.pending, label: Text('Pending')),
      ],
      selected: {selected},
      onSelectionChanged: (values) => onChanged(values.first),
    );
  }
}
