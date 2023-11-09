import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../modules/user.dart';
import '../utils/user_utils.dart';

/*import 'package:transparent_image/transparent_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
*/
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
          /*child: Hero(
            tag: "profile-image",*/
          child: CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage(
                "assets/images/logo.png") /*MemoryImage(
                UserUtils.imageToUint8List(UserUtils.base64ToImage(refresh(1)))*/
            ,
          ),
          /*child: CachedNetworkImage(
                imageUrl: 'data:image/png;base64,${refresh(1)}',
                placeholder: (context, url) => Image.memory(kTransparentImage),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                width: 10,
                height: 10,
              ),
            ),
          ),*/
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
