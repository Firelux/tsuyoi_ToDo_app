import 'package:flutter/material.dart';
import 'package:tsuyoi/pages/goals_management.dart';
import 'package:tsuyoi/pages/home.dart';

Drawer drawer(BuildContext context) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text('Drawer Header'),
        ),
        ListTile(
          title: const Text('Home'),
          onTap: () {
            // Update the state of the app
            // Then close the drawer
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
        ),
        ListTile(
          title: const Text('Obiettivi'),
          onTap: () {
            // Update the state of the app
            // Then close the drawer
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Management()));
          },
        ),
        ListTile(
          title: const Text('Calendario'),
          onTap: () {
            // Update the state of the app
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
