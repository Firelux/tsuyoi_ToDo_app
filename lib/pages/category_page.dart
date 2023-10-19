import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tsuyoi/modules/category.dart';
import 'package:tsuyoi/modules/goal.dart';
import 'package:tsuyoi/pages/category.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _goalsBox = Hive.box("goals_box");

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  List<Goal> _goals = [];
  List<Goal> _achivedGoals = [];
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

    setState(() {
      _goals = data.reversed.toList();
      _achivedGoals = achived.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.category.name),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Management())),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  return ListTile(
                    title: Text(goal.name),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
                child: ListView.builder(
                    itemCount: _achivedGoals.length,
                    itemBuilder: (context, index) {
                      final achived = _achivedGoals[index];
                      return ListTile(
                        title: Text(achived.name),
                      );
                    }))
          ],
        ));
  }
}
