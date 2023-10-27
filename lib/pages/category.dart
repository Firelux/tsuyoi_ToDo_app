import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tsuyoi/modules/category.dart';
import '../components/app_bar.dart';
import '../components/drawer.dart';
import '../components/bottom_navigation_bar.dart';
import 'package:tsuyoi/pages/category_page.dart';
import '../utils/category_utils.dart';

class Management extends StatefulWidget {
  const Management({Key? key}) : super(key: key);

  @override
  _ManagementState createState() => _ManagementState();
}

class _ManagementState extends State<Management> {
  final TextEditingController _categoryNameController = TextEditingController();

  final _categoriesBox = Hive.box("categories_box");

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  static List<dynamic> _categories = [];

  void _refreshItems() {
    final data = _categoriesBox.values.map((category) {
      return category;
    }).toList();

    setState(() {
      _categories = data.reversed.toList();
    });
  }

  Future<void> _updateItem(String itemKey, Category item) async {
    await _categoriesBox.put(item.id, item);
    _refreshItems();
  }

  Future<void> _deleteItem(String itemKey) async {
    await _categoriesBox.delete(itemKey);
    _refreshItems();
  }

  void _showForm(BuildContext context, String? itemKey) async {
    if (itemKey != null && _categoriesBox.get(itemKey) is Category) {
      final existingItem = _categoriesBox.get(itemKey) as Category;
      _categoryNameController.text = existingItem.name;
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
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _categoryNameController,
                    decoration: const InputDecoration(hintText: "name"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (itemKey == null) {
                          CategoryUtils.createCategory(_categoryNameController,
                              () {
                            _refreshItems();
                          });
                        }

                        if (itemKey != null) {
                          _updateItem(
                              itemKey,
                              Category(
                                id: itemKey,
                                name: _categoryNameController.text.trim(),
                              ));
                        }
                        _categoryNameController.text = "";

                        Navigator.of(context).pop();
                      },
                      child:
                          Text(itemKey == null ? "Add new category" : "Update"))
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(context),
      body: ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (_, index) {
            final currentItem = _categories[index];
            return Card(
              color: Colors.blue.shade300,
              margin: const EdgeInsets.all(10),
              elevation: 3,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(category: currentItem),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    currentItem.name,
                    selectionColor: Colors.black,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showForm(context, currentItem.id),
                      ),
                      IconButton(
                        onPressed: () =>
                            CategoryUtils.deleteCategory(currentItem.id, () {
                          _refreshItems();
                        }),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(context, null);
        },
        tooltip: 'Add category',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }
}
