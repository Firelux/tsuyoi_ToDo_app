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



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();

  String searchQuery = "SearchQuery";
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

  void _createItem() async {
    final timestampKey = DateTime.now().millisecondsSinceEpoch.toString();
    final newGoal = Goal(
      id: timestampKey,
      name: _nameController.text,
      category: selectedItem,
      completed: false,
    );
    await _goalsBox.put(newGoal.id, newGoal);
    _refreshItems();
  }

  Future<void> _updateItem(String itemKey, Goal item) async {
    await _goalsBox.put(itemKey, item);
    _refreshItems();
  }

  Future<void> _deleteItem(String itemKey) async {
    await _goalsBox.delete(itemKey);
    _refreshItems();
  }

  void _showForm(BuildContext context, String? itemKey) async {
    if (itemKey != null && _goalsBox.get(itemKey) is Goal) {
      final existingItem = _goalsBox.get(itemKey) as Goal;
      _nameController.text = existingItem.name;
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
              controller: _nameController,
              decoration: const InputDecoration(hintText: "name"),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedItem,
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.name,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (item) {
                setState(() => selectedItem = item ?? "");
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (itemKey == null) {
                  _createItem();
                } else {
                  _updateItem(
                    itemKey,
                    Goal(
                      id: itemKey,
                      name: _nameController.text.trim(),
                      category: selectedItem,
                      completed: false,
                    ),
                  );
                }

                _nameController.text = "";
                Navigator.of(context).pop();
              },
              child: Text(itemKey == null ? "Add new goal" : "Update"),
            ),
          ],
        ),
      ),
    );
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
                        onEdit: (goal) => _showForm(context, goal.id),
                        onDelete: (goal) => _deleteItem(goal.id),
                      );
                    },
                  ),
                ])),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(context, null);
        },
        tooltip: 'Add goal',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }
}
