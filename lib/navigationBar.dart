import 'package:flutter/material.dart';
import 'package:flutter_application_2/profile/user.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final User user;

  CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemSelected,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.photo_camera, 'Picture', 0),
          _buildNavItem(Icons.map, 'Map', 1),
          _buildNavItem(Icons.restore_from_trash_rounded, 'All', 2),
          _buildNavItemWithImage(user.image, '', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = index == selectedIndex;
    final color = isSelected ? Colors.white : Colors.grey;
    return Expanded(
      child: TextButton(
        onPressed: () => onItemSelected(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
            ),
            Text(
              label,
              style: TextStyle(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemWithImage(String image, String label, int index) {
    final isSelected = index == selectedIndex;
    final color = isSelected ? Colors.blue : Colors.grey;
    return Expanded(
      child: TextButton(
        onPressed: () => onItemSelected(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/profilePicture/"+image,
              width: 30,
              height: 30,
            ),
            Text(
              label,
              style: TextStyle(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
