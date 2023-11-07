import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tsuyoi/modules/goal.dart';
import 'package:tsuyoi/utils/category_utils.dart';
import '../modules/category.dart';

String selectedItem = "";

class GoalManagementUtils {
  static Future<void> createGoal(
      TextEditingController nameController, String selectedItem) async {
    final goalsBox = Hive.box("goals_box");
    final timestampKey = DateTime.now().millisecondsSinceEpoch.toString();
    final newGoal = Goal(
      id: timestampKey,
      name: nameController.text,
      category: selectedItem,
      daily: false,
      completed: false,
    );
    await goalsBox.put(newGoal.id, newGoal);
  }

  static Future<void> updateGoal(String itemKey, Goal item) async {
    final goalsBox = Hive.box("goals_box");
    await goalsBox.put(itemKey, item);
  }

  static Future<void> deleteGoal(String itemKey) async {
    final goalsBox = Hive.box("goals_box");
    await goalsBox.delete(itemKey);
  }

  static void showGoalForm(BuildContext context, String? itemKey,
      Function() onConfirm, List<Category> categories) {
    final goalsBox = Hive.box("goals_box");
    final nameController = TextEditingController();

    if (itemKey != null && goalsBox.get(itemKey) is Goal) {
      final existingItem = goalsBox.get(itemKey) as Goal;
      nameController.text = existingItem.name;
    }

    if (categories.isNotEmpty) {
      selectedItem = categories[0].name;
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "name"),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedItem,
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.name,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (item) {
                selectedItem = item ?? "";
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (itemKey == null) {
                  createGoal(nameController,
                      CategoryUtils.findCategoryByName(selectedItem));
                } else {
                  updateGoal(
                    itemKey,
                    Goal(
                      id: itemKey,
                      name: nameController.text.trim(),
                      category: CategoryUtils.findCategoryByName(selectedItem),
                      daily: false,
                      completed: false,
                    ),
                  );
                }

                nameController.text = "";
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text(itemKey == null ? "Add new goal" : "Update"),
            ),
          ],
        ),
      ),
    );
  }

  static void showCustomModal(
      BuildContext context, String id, Function() onConfirm, int context_) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: context == 0
              ? const Text('Are you sure you want to delete this task?')
              : const Text(
                  'Are you sure you want to delete this category? All goals with this category will also be deleted'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (context_ == 0) {
                  deleteGoal(id);
                  onConfirm();
                } else {
                  final goals = Hive.box("goals_box")
                      .values
                      .map((goal) => goal as Goal)
                      .toList();
                  for (int i = 0; i < goals.length; i++) {
                    if (goals[i].category == id) {
                      deleteGoal(goals[i].id);
                    }
                  }
                  CategoryUtils.deleteCategory(id, () => onConfirm());
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
