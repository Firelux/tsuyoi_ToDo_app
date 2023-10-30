import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/bottom_navigation_bar.dart';
import 'package:tsuyoi/modules/goal.dart';
import 'package:tsuyoi/modules/category.dart';
import 'package:tsuyoi/screens/category_page.dart';

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

  void _refreshCategory() {
    final categoriesData =
        _categoriesBox.values.map((category) => category as Category).toList();

    setState(() {
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
          Column(
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Categories",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 115,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      CategoryUtils.showCategoryForm(context, null, () {
                        _refreshItems();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Add Category'),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
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
                      CategoryUtils.showCategoryForm(context, category.id, () {
                        _refreshItems();
                      });
                    },
                    onDelete: (categoryId) {
                      CategoryUtils.deleteCategory(categoryId, () {
                        _refreshItems();
                      });
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
              child: ListView(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  const Text(
                    "My Tasks",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: _goals.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (_, index) {
                      final currentGoal = _goals[index];
                      return GoalCard(
                        goal: currentGoal,
                        onEdit: (goal) => GoalManagementUtils.showGoalForm(
                          context,
                          goal.id,
                          () {
                            _refreshItems();
                          },
                          _categories,
                        ),
                        onDelete: (goal) {
                          GoalManagementUtils.showCustomModal(context, goal.id,
                              () {
                            _refreshItems();
                          });
                        },
                        isDaily: currentGoal.daily,
                        onDaily: (daily) {
                          setState(() {
                            currentGoal.daily = daily;

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
                ],
              ),
            ),
        ],
      ),

      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                GoalManagementUtils.showGoalForm(context, null, () {
                  _refreshItems();
                }, _categories);
              },
              tooltip: 'Add goal',
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add_task),
            ),
          ),
        ],
      ),

      bottomNavigationBar: bottomNavigationBar(context),
    );
  }
}
