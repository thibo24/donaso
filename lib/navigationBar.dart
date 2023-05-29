import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  CustomBottomNavigationBar(
      {required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
            label: 'Picture',
            backgroundColor: Colors.black),
        BottomNavigationBarItem(
            icon: Icon(Icons.map), label: 'Map', backgroundColor: Colors.black),
        BottomNavigationBarItem(
            icon: Icon(Icons.restore_from_trash_rounded),
            label: 'All',
            backgroundColor: Colors.black),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.black),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.lightGreenAccent,
      onTap: onItemSelected,
    );
  }
}
