import 'package:flutter/material.dart';

AppBar appBar() {
  return AppBar(
    title: const Text(
      "Tsuyoi",
    ),
    centerTitle: false,
    actions: [
      IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
    ],
  );
}
