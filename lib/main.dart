import 'package:hive_flutter/adapters.dart';
import 'package:tsuyoi/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tsuyoi/modules/goal.dart';
import 'package:tsuyoi/modules/category.dart';
import 'package:tsuyoi/modules/user.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GoalAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(UserAdapter());
  //await Hive.deleteBoxFromDisk("categories_box");
  //await Hive.deleteBoxFromDisk("goals_box");
  //await Hive.deleteBoxFromDisk("user_box");
  await Hive.openBox('goals_box');
  await Hive.openBox('categories_box');
  await Hive.openBox('user_box');
  await Hive.openBox('date_box');
  //box.clear();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.dark),
      home: const HomePage(),
    );
  }
}
