import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/appBar.dart';
import '../components/drawer.dart';
import '../components/bottomNavigationBar.dart';


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

  static List<Map<String, dynamic>> _categories = [];

  void _refreshItems() {
    final data = _categoriesBox.keys.map((key) {
      final item = _categoriesBox.get(key);
      return {
        "key": key,
        "name": item["name"],
      };
    }).toList();

    setState(() {
      _categories = data.reversed.toList();
      print(_categories.length);
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _categoriesBox.add(newItem);
    _refreshItems();
  }

  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _categoriesBox.put(itemKey, item);
    _refreshItems();
  }

  Future<void> _deleteItem(int itemKey) async {
    await _categoriesBox.delete(itemKey);
    _refreshItems();
  }

  Future<List<Map<String, dynamic>>> _getCategories() async {
    final data = _categoriesBox.keys.map((key) {
      final item = _categoriesBox.get(key);
      return {
        "key": key,
        "name": item["name"],
      };
    }).toList();

    return data.reversed.toList();
  }

  List<Map<String, dynamic>> getCategories() {
    return _categories;
  }

  void _showForm(BuildContext context, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          _categories.firstWhere((element) => element['key'] == itemKey);
      _categoryNameController.text = existingItem['name'];
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
                          _createItem({
                            "name": _categoryNameController.text,
                          });
                        }

                        if (itemKey != null) {
                          _updateItem(itemKey, {
                            "name": _categoryNameController.text.trim(),
                          });
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
                child: ListTile(
                    title: Text(
                      currentItem['name'],
                      selectionColor: Colors.black,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showForm(context, currentItem['key']),
                        ),
                        IconButton(
                            onPressed: () => _deleteItem(currentItem['key']),
                            icon: const Icon(Icons.delete))
                      ],
                    )));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(context, null);
        },
        tooltip: 'Add category',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }
}
