import 'package:flutter/material.dart';
import 'package:tsuyoi/screens/home.dart';
import 'package:tsuyoi/screens/daily.dart';
import '../screens/profile.dart';

BottomNavigationBar bottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.diamond_rounded),
        label: 'Daily',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    onTap: (
      int index,
    ) {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Daily()));
      } else if (index == 2) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
      }
    },
  );
}
