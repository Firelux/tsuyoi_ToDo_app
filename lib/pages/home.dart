import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/bottom_navigation_bar.dart';
import 'package:tsuyoi/modules/goal.dart';
import 'package:tsuyoi/modules/category.dart';
import 'package:tsuyoi/pages/category_page.dart';

String? name = "Firelux";

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

    if (_categories.isNotEmpty) {
      selectedItem = _categories[0].name;
    }

    print(selectedItem);
  }

  void _refreshItems() {
    final data = _goalsBox.values.map((goal) => goal as Goal).toList();
    final categoriesData =
        _categoriesBox.values.map((category) => category as Category).toList();

    print(selectedItem);

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
      appBar: AppBar(
        centerTitle: false,
        leading: const CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
          backgroundColor: Colors.transparent,
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '$name',
              textAlign: TextAlign.left,
            ),
            Text(
              "Welcome $name",
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),

      //drawer: drawer(context),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: 20,
            ),
          ),
          SizedBox(
            height: 260,
            child: ListView.builder(
              itemCount: _categories.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final currentItem = _categories[index];
                return SizedBox(
                  width: 300,
                  child: Card(
                    color: Color(0xFF673AB7),
                    margin: const EdgeInsets.all(10),
                    elevation: 3,
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          color: Color(0xFF2196F3),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryPage(category: currentItem),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(
                                currentItem.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    iconSize: 24,
                                    onPressed: () =>
                                        _showForm(context, currentItem.id),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    iconSize: 24,
                                    onPressed: () =>
                                        _deleteItem(currentItem.id),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          child: const Text(
                            "Progress:",
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 240,
                          child: LinearProgressIndicator(
                            value: 0.6,
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Color(0xFF9E9E9E),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 15,
              left: 15,
              right: 15,
            ),
            child: const Text(
              "My Tasks",
              style: TextStyle(fontSize: 19),
            ),
          ),
          ListView.builder(
            itemCount: _goals.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              final currentGoal = _goals[index];
              return Card(
                color: Colors.blue.shade200,
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    currentGoal.name,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    currentGoal.category,
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
                        onPressed: () => _showForm(context, currentGoal.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        iconSize: 24,
                        onPressed: () => _deleteItem(currentGoal.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
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
