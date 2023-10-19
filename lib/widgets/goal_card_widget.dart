import 'package:flutter/material.dart';
import 'package:tsuyoi/modules/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final Function(Goal) onEdit;
  final Function(Goal) onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade200,
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: ListTile(
        title: Text(
          goal.name,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          goal.category,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              iconSize: 24,
              onPressed: () => onEdit(goal),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              iconSize: 24,
              onPressed: () => onDelete(goal),
            ),
          ],
        ),
      ),
    );
  }
}
