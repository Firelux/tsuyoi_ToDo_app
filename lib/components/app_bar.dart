import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../modules/user.dart';
import '../utils/user_utils.dart';

String refresh(int context) {
  final userBox = Hive.box("user_box");
  
  if (userBox.isNotEmpty) {
    User user = userBox.get(0);
    
    switch (context) {
      case 0:
        return user.name;
      case 1:
        return user.profileImage;
      default:
        return "";
    }
  } else {
        switch (context) {
      case 0:
        return "";
      case 1:
        return UserUtils.unknownImage();
      default:
        return "";
    }
  }
}

AppBar appBar() {
  return AppBar(
    centerTitle: false,
    leading: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 28.0,
            backgroundImage: MemoryImage(UserUtils.imageToUint8List(
                UserUtils.base64ToImage(refresh(1)))),
          ),
        ),
      ],
    ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          refresh(0),
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    ),
  );
}
