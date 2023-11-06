import 'package:hive/hive.dart';

class User {
  int id;
  String name;
  String profileImage;

  User({
    required this.id,
    required this.name,
    required this.profileImage,
  });
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final id = reader.readInt();
    final name = reader.readString();
    final profileImage = reader.readString();

    return User(id: id, name: name, profileImage: profileImage);
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.profileImage);
  }
}
