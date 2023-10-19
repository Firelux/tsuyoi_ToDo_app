import 'package:flutter/material.dart';
import 'package:tsuyoi/modules/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final Function(Category) onTap;
  final Function(Category) onEdit;
  final Function(String) onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        color: const Color(0xFF673AB7),
        margin: const EdgeInsets.all(10),
        elevation: 3,
        child: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              color: const Color(0xFF2196F3),
              child: GestureDetector(
                onTap: () {
                  onTap(category);
                },
                child: ListTile(
                  title: Text(
                    category.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        iconSize: 24,
                        onPressed: () {
                          onEdit(category);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        iconSize: 24,
                        onPressed: () {
                          onDelete(category.id);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              "Progress:",
              textAlign: TextAlign.left,
            ),
            const Spacer(),
            SizedBox(
              width: 240,
              child: LinearProgressIndicator(
                value: 0.6,
                minHeight: 12,
                borderRadius: BorderRadius.circular(10),
                backgroundColor: const Color(0xFF9E9E9E),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
