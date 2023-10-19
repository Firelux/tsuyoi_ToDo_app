import 'package:flutter/material.dart';
import 'package:tsuyoi/pages/home.dart';
import 'package:tsuyoi/pages/category.dart';

final List<Widget> _screens = [
  const HomePage(),
];

int _selectedIndex = 0;

// void _onItemTapped(int index) {
//   setState(() {
//     _selectedIndex = index;
//   });
// }

BottomNavigationBar bottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.emoji_objects),
        label: 'Obiettivi',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profilo',
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
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Management()));
      } else if (index == 2) {}
    },
  );
}
