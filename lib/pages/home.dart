import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/bottom_navigation_bar.dart';
import 'package:tsuyoi/modules/goal.dart';
import 'package:tsuyoi/modules/category.dart';
import 'package:tsuyoi/pages/category_page.dart';

import 'package:tsuyoi/pages/category.dart';
import '../components/app_bar.dart';
import '../widgets/category_card_widget.dart';
import '../widgets/goal_card_widget.dart';
import '../utils/category_utils.dart';
import '../utils/goal_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _goalsBox = Hive.box("goals_box");
  final _categoriesBox = Hive.box("categories_box");

  List<Goal> _goals = [];
  List<Category> _categories = [];
  String selectedItem = "";

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _goalsBox.values.map((goal) => goal as Goal).toList();
    final categoriesData =
        _categoriesBox.values.map((category) => category as Category).toList();

    setState(() {
      _goals = data.reversed.toList();
      _categories = categoriesData.reversed.toList();

      if (_categories.isNotEmpty) {
        selectedItem = _categories[0].name;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(), //drawer: drawer(context),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: 20,
            ),
          ),
          if (_categories.isEmpty)
            SizedBox(
              width: 100,
              height: 260,
              child: Card(
                  color: const Color(0xFF673AB7),
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Management(),
                        ),
                      );
                    },
                  )),
            ),
          SizedBox(
              height: 260,
              child: ListView.builder(
                itemCount: _categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final currentCategory = _categories[index];
                  return CategoryCard(
                    category: currentCategory,
                    onTap: (category) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryPage(category: category),
                        ),
                      );
                    },
                    onEdit: (category) {
                      CategoryUtils.showCategoryForm(context, category.id);
                    },
                    onDelete: (categoryId) {
                      CategoryUtils.deleteCategory(categoryId);
                      _refreshItems();
                    },
                  );
                },
              )),
          if (_categories.isNotEmpty)
            Container(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  top: 15,
                  left: 15,
                  right: 15,
                ),
                child: Column(children: [
                  const Text(
                    "My Tasks",
                    style: TextStyle(fontSize: 19),
                  ),
                  ListView.builder(
                    itemCount: _goals.length,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      final currentGoal = _goals[index];
                      return GoalCard(
                        goal: currentGoal,
                        onEdit: (goal) => GoalManagementUtils.showGoalForm(
                            context, goal.id, () {
                          _refreshItems();
                        }, _categories),
                        onDelete: (goal) {
                          GoalManagementUtils.showCustomModal(context, goal.id,
                              () {
                            _refreshItems();
                          });
                        },
                        isChecked: currentGoal.completed,
                        onCheck: (goal) => {
                          setState(() {
                            currentGoal.completed = goal;
                            _refreshItems();
                          })
                        },
                      );
                    },
                  ),
                ])),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoalManagementUtils.showGoalForm(context, null, () {
            _refreshItems();
          }, _categories);
        },
        tooltip: 'Add goal',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }
}
