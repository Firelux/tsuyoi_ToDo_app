import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/appBar.dart';
import '../components/drawer.dart';
import '../components/bottomNavigationBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _categories = [];

  String? selectedItem;

  final _goalsBox = Hive.box("goals_box");
  final _categoriesBox = Hive.box("categories_box");

  @override
  void initState() {
    super.initState();
    _refreshItems();

    if (_categories.isNotEmpty) {
      selectedItem = _categories[0]['name'].toString();
    }

    print(selectedItem);
  }

  void _refreshItems() {
    final data = _goalsBox.keys.map((key) {
      final item = _goalsBox.get(key);
      return {
        "key": key,
        "name": item["name"],
        "quantity": item['quantity'],
        "category": selectedItem
      };
    }).toList();

    final categoriesData = _categoriesBox.keys.map((key) {
      final item = _categoriesBox.get(key);
      return {"key": key, "name": item["name"]};
    }).toList();

    final selectedCategoryData = selectedItem;
    print(selectedItem);

    setState(() {
      _items = data.reversed.toList();
      _categories = categoriesData.reversed.toList();
      selectedItem = selectedCategoryData.toString();
      print(_items.length);
      print(_categories.length);
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _goalsBox.add(newItem);
    _refreshItems();
  }

  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _goalsBox.put(itemKey, item);
    _refreshItems();
  }

  Future<void> _deleteItem(int itemKey) async {
    await _goalsBox.delete(itemKey);
    _refreshItems();
  }

  void _showForm(BuildContext context, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _quantityController.text = existingItem['quantity'];
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
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: "name"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButton<String>(
                    value: selectedItem,
                    items: _categories
                        .map((category) => DropdownMenuItem<String>(
                              value: category['name'].toString(),
                              child: Text(category['name'].toString()),
                            ))
                        .toList(),
                    onChanged: (item) {
                      setState(() => selectedItem = item);
                      _refreshItems();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (itemKey == null) {
                          _createItem({
                            "name": _nameController.text,
                            "quantity": _quantityController.text,
                            "category": "",
                          });
                        }

                        if (itemKey != null) {
                          _updateItem(itemKey, {
                            "name": _nameController.text.trim(),
                            "quantity": _quantityController.text.trim(),
                            "category": selectedItem,
                          });
                        }

                        _nameController.text = "";
                        _quantityController.text = "";

                        Navigator.of(context).pop();
                      },
                      child: Text(itemKey == null ? "Add new goal" : "Update"))
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
          itemCount: _items.length,
          itemBuilder: (_, index) {
            final currentItem = _items[index];
            return Card(
                color: Colors.blue.shade200,
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                    title: Text(
                      currentItem['name'],
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      selectedItem.toString(),
                      style: TextStyle(
                        color: Colors.black,
                      ),
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
        tooltip: 'Add goal',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }
}
