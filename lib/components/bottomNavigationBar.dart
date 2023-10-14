import 'package:flutter/material.dart';
import 'package:tsuyoi/pages/home.dart';

final List<Widget> _screens = [
  const HomePage(),
  //Goals(),
  // Altre schermate, ad esempio ProfileScreen()
];

int _selectedIndex = 0;

// void _onItemTapped(int index) {
//   setState(() {
//     _selectedIndex = index;
//   });
// }

BottomNavigationBar bottomNavigationBar() {
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
    // currentIndex: selectedIndex,
    // onTap: onItemTapped,
  );
}
