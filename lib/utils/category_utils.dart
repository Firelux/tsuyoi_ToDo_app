import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tsuyoi/modules/category.dart';

class CategoryUtils {
  static Future<void> createCategory(
      TextEditingController categoryNameController, Function() refresh) async {
    final categoriesBox = Hive.box("categories_box");
    final timestampKey = DateTime.now().millisecondsSinceEpoch.toString();
    final newCategory = Category(
      id: timestampKey,
      name: categoryNameController.text,
    );
    await categoriesBox.put(newCategory.id, newCategory);
    refresh();
  }

  static Future<void> updateCategory(String itemKey, Category item) async {
    final categoriesBox = Hive.box("categories_box");
    await categoriesBox.put(itemKey, item);
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
              controller: categoryNameController,
              decoration: const InputDecoration(hintText: "name"),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (itemKey == null) {
                  createCategory(categoryNameController, refresh());
                } else {
                  updateCategory(
                    itemKey,
                    Category(
                      id: itemKey,
                      name: categoryNameController.text.trim(),
                    ),
                  );
                }

                categoryNameController.text = "";
                Navigator.of(context).pop();
              },
              child: Text(itemKey == null ? "Add new category" : "Update"),
            ),
          ],
        ),
      ),
    );
  }
}
