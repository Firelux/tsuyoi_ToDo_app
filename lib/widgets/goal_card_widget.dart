import 'package:flutter/material.dart';
import 'package:tsuyoi/modules/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final Function(Goal) onEdit;
  final Function(Goal) onDelete;
  final bool isChecked;
  final Function(bool) onCheck;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onEdit,
    required this.onDelete,
    required this.isChecked,
    required this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isChecked ? Colors.green : Colors.blue.shade200,
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          AppBar(
            backgroundColor: isChecked ? Colors.green : Colors.blue.shade200,
            title: Text(
              goal.category,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                onPressed: () => onEdit(goal),
              ),
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text('Delete'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 1) {
                    onEdit(goal);
                  } else if (value == 2) {
                    onDelete(goal);
                  }
                },
              ),
            ],
          ),
          ListTile(
            title: Text(
              goal.name,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            trailing: IconButton(
              icon: isChecked
                  ? const Icon(Icons.check_box)
                  : const Icon(Icons.check_box_outline_blank),
              iconSize: 24,
              onPressed: () => onCheck(!isChecked),
            ),
          ),
        ],
      ),
    );
  }
}
