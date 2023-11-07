import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tsuyoi/modules/category.dart';
import 'package:tsuyoi/modules/goal.dart';
//import 'package:tsuyoi/screens/category.dart';
import '../utils/goal_utils.dart';
import '../widgets/goal_card_widget.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _goalsBox = Hive.box("goals_box");
  final _categoriesBox = Hive.box("categories_box");

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  List<Goal> _goals = [];
  List<Goal> _achivedGoals = [];
  List<Category> _categories = [];
  void _refreshItems() {
    final data = _goalsBox.values
        .map((goal) => goal as Goal)
        .where(
            (goal) => goal.category == widget.category.name && !goal.completed)
        .toList();
    final achived = _goalsBox.values
        .map((goal) => goal as Goal)
        .where(
            (goal) => goal.category == widget.category.name && goal.completed)
        .toList();

    final categories =
        _categoriesBox.values.map((category) => category as Category).toList();

    setState(() {
      _goals = data.reversed.toList();
      _achivedGoals = achived.reversed.toList();
      _categories = categories.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.category.name),
          /*leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Management())),
          ),*/
        ),
        body: Column(
          children: [
            const Text(
              "To do",
              style: TextStyle(fontSize: 25),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  return GoalCard(
                    goal: goal,
                    onEdit: (goal) => GoalManagementUtils.showGoalForm(
                      context,
                      goal.id,
                      () {
                        _refreshItems();
                      },
                      _categories,
                    ),
                    onDelete: (goal) {
                      GoalManagementUtils.showCustomModal(context, goal.id, () {
                        _refreshItems();
                      }, 0);
                    },
                    isDaily: goal.daily,
                    onDaily: (daily) {
                      setState(() {
                        goal.daily = daily;

                        _refreshItems();
                      });
                    },
                    isChecked: goal.completed,
                    onCheck: (completed) => {
                      setState(() {
                        goal.completed = completed;
                        _refreshItems();
                      })
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            const Text("Completed",
                style: TextStyle(
                  fontSize: 20,
                )),
            Expanded(
                child: ListView.builder(
                    itemCount: _achivedGoals.length,
                    itemBuilder: (context, index) {
                      final achived = _achivedGoals[index];
                      return Card(
                        color: Colors.green,
                        margin: const EdgeInsets.all(10),
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            achived.name,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            icon: achived.completed
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            iconSize: 24,
                            onPressed: () => {
                              achived.completed = !achived.completed,
                              _refreshItems()
                            },
                          ),
                        ),
                      );
                    }))
          ],
        ));
  }
}
