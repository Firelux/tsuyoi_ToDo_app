import 'package:flutter/material.dart';
import 'package:tsuyoi/modules/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final Function(Goal) onEdit;
  final Function(Goal) onDelete;
  final bool isChecked;
  final Function(bool) onCheck;
  final bool isDaily;
  final Function(bool) onDaily;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onEdit,
    required this.onDelete,
    required this.isChecked,
    required this.onCheck,
    required this.isDaily,
    required this.onDaily,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Card(
          color: isChecked ? Colors.green : Colors.blue.shade200,
          margin: const EdgeInsets.all(10),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppBar(
                backgroundColor:
                    isChecked ? Colors.green : Colors.blue.shade200,
                title: Text(
                  goal.name,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.star,
                      color: isDaily ? Colors.amber : Colors.blueGrey,
                    ),
                    onPressed: () => onDaily(!isDaily),
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
                  goal.category,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: IconButton(
                  icon: isChecked
                      ? const Icon(Icons.check_circle)
                      : const Icon(Icons.circle),
                  iconSize: 28,
                  onPressed: () => onCheck(!isChecked),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
