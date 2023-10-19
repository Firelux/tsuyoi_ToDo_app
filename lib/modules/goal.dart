
import 'package:hive/hive.dart';

class Goal {
  String id;
  String name;
  String category;
  bool completed; // Cambiato da "Bool" a "bool"

  Goal({
    required this.id,
    required this.name,
    required this.category,
    required this.completed,

  });

  String getName() {
    return name;
  }
}


class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final int typeId = 0; // Un identificativo univoco per l'adattatore

  @override
  Goal read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final category = reader.readString();
    final completed = reader.readBool(); // Leggi il campo booleano "completed"
    return Goal(id: id, name: name, category: category, completed: completed);
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.category);
    writer.writeBool(obj.completed); // Scrivi il campo booleano "completed"
  }
}

