import 'package:hive/hive.dart';

class Goal {
  String id;
  String name;
  String category;
  bool completed;
  bool daily;

  Goal({
    required this.id,
    required this.name,
    required this.category,
    required this.completed,
    required this.daily,
  });

  String getName() {
    return name;
  }
}

class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final int typeId = 0;

  @override
  Goal read(BinaryReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final category = reader.readString();
    final completed = reader.readBool();
    final daily = reader.readBool(); // Leggi il campo booleano "daily"
    return Goal(
        id: id,
        name: name,
        category: category,
        completed: completed,
        daily: daily);
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.category);
    writer.writeBool(obj.completed);
    writer.writeBool(obj.daily); // Scrivi il campo booleano "daily"
  }
}
