import 'package:hive/hive.dart';

class Category {
  String id;
  String name;

  Category({
    required this.id,
    required this.name,
  });
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1;

  @override
  Category read(BinaryReader reader) {
    final id = reader.read();
    final name = reader.read();
    return Category(id: id, name: name);
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.write(obj.id);
    writer.write(obj.name);
  }
}
