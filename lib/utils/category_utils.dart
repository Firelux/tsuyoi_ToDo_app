import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tsuyoi/modules/category.dart';

class CategoryUtils {
  static Future<void> createCategory(
      String categoryName, Function() refresh) async {
    final categoriesBox = Hive.box("categories_box");
    final timestampKey = DateTime.now().millisecondsSinceEpoch.toString();
    final newCategory = Category(
      id: timestampKey,
      name: categoryName,
    );
    await categoriesBox.put(newCategory.id, newCategory);
    refresh();
  }

  static String findCategoryByName(String name) {
    final categories = Hive.box("categories_box")
        .values
        .map((category) => category as Category)
        .toList();

    for (int i = 0; i < categories.length; i++) {
      if (categories[i].name == name) {
        return categories[i].id;
      }
    }
    return "";
  }

  static String findCategoryById(String id) {
    final categories = Hive.box("categories_box")
        .values
        .map((category) => category as Category)
        .toList();

    for (int i = 0; i < categories.length; i++) {
      if (categories[i].id == id) {
        return categories[i].name;
      }
    }
    return "";
  }

  static Future<void> updateCategory(
      String itemKey, Category item, Function() refresh) async {
    final categoriesBox = Hive.box("categories_box");
    await categoriesBox.put(itemKey, item);
    refresh();
  }

  static Future<void> deleteCategory(String itemKey, Function() refresh) async {
    final categoriesBox = Hive.box("categories_box");
    await categoriesBox.delete(itemKey);
    refresh();
  }

  static void showCategoryForm(
      BuildContext context, String? itemKey, Function() refresh) {
    final categoriesBox = Hive.box("categories_box");
    final categoryNameController = TextEditingController();

    if (itemKey != null && categoriesBox.get(itemKey) is Category) {
      final existingItem = categoriesBox.get(itemKey) as Category;
      categoryNameController.text = existingItem.name;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(itemKey == null ? "Add new category" : "Update"),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: categoryNameController,
                  decoration: const InputDecoration(hintText: "name"),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (itemKey == null) {
                  createCategory(categoryNameController.text, () {
                    refresh();
                  });
                } else {
                  updateCategory(
                      itemKey,
                      Category(
                        id: itemKey,
                        name: categoryNameController.text.trim(),
                      ), () {
                    refresh();
                  });
                }

                categoryNameController.text = "";
                Navigator.of(context).pop();
              },
              child: Text(itemKey == null ? "Add new category" : "Update"),
            ),
          ],
        );
      },
    );
  }
}
