import 'package:flutter/material.dart';

String? name = "Firelux";

AppBar appBar() {
  return AppBar(
    centerTitle: false,
    leading: const Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 28.0,
            backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$name',
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          "Welcome $name",
          style: const TextStyle(fontSize: 16),
        )
      ],
    ),
  );
}
