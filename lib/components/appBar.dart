import 'package:flutter/material.dart';

AppBar appBar() {
  return AppBar(
    title: const Text(
      "Tsuyoi",
    ),
    centerTitle: true,
    actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
  );
}
