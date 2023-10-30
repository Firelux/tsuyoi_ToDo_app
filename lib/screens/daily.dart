import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tsuyoi/modules/category.dart';
import '../components/app_bar.dart';
import '../utils/goal_utils.dart';
import '../components/bottom_navigation_bar.dart';
import '../widgets/goal_card_widget.dart';
import '../modules/goal.dart';

class Daily extends StatefulWidget {
  const Daily({Key? key}) : super(key: key);

  @override
  _DailyState createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  final goalsBox = Hive.box("goals_box");
  final categoriesBox = Hive.box("categories_box");

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  static List<dynamic> daily = [];

  List<Goal> _achivedDaily = [];
  List<Category> _categories = [];
  void _refreshItems() {
    final data = goalsBox.values
        .map((goal) => goal as Goal)
        .where((goal) => goal.daily && !goal.completed)
        .toList();
    final achived = goalsBox.values
        .map((goal) => goal as Goal)
        .where((goal) => goal.daily && goal.completed)
        .toList();

    final categories =
        categoriesBox.values.map((category) => category as Category).toList();

    setState(() {
      daily = data.reversed.toList();
      _achivedDaily = achived.reversed.toList();
      _categories = categories.reversed.toList();
    });
  }

  double value() {
    final dailyGoals = goalsBox.values
        .map((goal) => goal as Goal)
        .where((goal) => goal.daily)
        .toList();

    return dailyGoals.isNotEmpty
        ? dailyGoals.where((goal) => goal.completed).length / dailyGoals.length
        : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      //drawer: drawer(context),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.start, // Imposta l'allineamento a sinistra
            children: [
              Text(
                "Progress: ${(value() * 100).toStringAsFixed(0)}%",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 12,
                width: 300,
                child: LinearProgressIndicator(
                  value: value(),
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: const Color(0xFF9E9E9E),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "To do",
            style: TextStyle(fontSize: 25),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: daily.length,
              itemBuilder: (context, index) {
                final goal = daily[index];
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
                    });
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
          if (_achivedDaily.isNotEmpty)
            const Text("Completed",
                style: TextStyle(
                  fontSize: 20,
                )),
          Expanded(
              child: ListView.builder(
                  itemCount: _achivedDaily.length,
                  itemBuilder: (context, index) {
                    final achived = _achivedDaily[index];
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
      ),
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }
}
