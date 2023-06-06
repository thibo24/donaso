import 'package:flutter/material.dart';
import 'package:flutter_application_2/profile/user.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  User user;

  CustomBottomNavigationBar(
      {required this.selectedIndex, required this.onItemSelected, required this.user});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
            label: 'Picture',
            backgroundColor: Colors.black),
        const BottomNavigationBarItem(
            icon: Icon(Icons.map), label: 'Map', backgroundColor: Colors.black),
        const BottomNavigationBarItem(
            icon: Icon(Icons.restore_from_trash_rounded),
            label: 'All',
            backgroundColor: Colors.black),
        BottomNavigationBarItem(
            icon: Image.asset(user.image,
                width: 50,
                height: 50,
            ),
            label: 'Profile',
            backgroundColor: Colors.black),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.lightGreenAccent,
      onTap: onItemSelected,
    );
  }
}
