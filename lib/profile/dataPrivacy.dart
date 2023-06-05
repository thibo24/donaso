import 'package:flutter/material.dart';
import 'package:flutter_application_2/profile/profileActivity.dart';
import 'package:flutter_application_2/profile/user.dart';
import '../database.dart';
import '../navigationBar.dart';

class dataPrivacy extends StatefulWidget {
  User user;
  final Database db;
  final int selectedIndex;
  final Function(int) onItemSelected;

  dataPrivacy({required this.user, required this.db, required this.selectedIndex, required this.onItemSelected});

  @override
  _dataPrivacyState createState() => _dataPrivacyState();
}

class _dataPrivacyState extends State<dataPrivacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: widget.selectedIndex,
        onItemSelected: widget.onItemSelected,
      ),
      backgroundColor: Colors.white,
      body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => profileActivity(
                                user: widget.user,
                                database: widget.db,
                                selectedIndex: widget.selectedIndex,
                                onPageSelected: widget.onItemSelected,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 50),
                      const Center(
                        child: Text(
                          'About your privacy',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1.5,
                  ),
                  const Expanded(
                    child: Text("Lorem ipsum dolor sit amet, consectetu adipiscing elit. Phasellus ultricies fermentum interdum. Nullam eu tellus in magna congue eleifend vel quis mi. Curabitur consectetur orci sed pharetra pellentesque. Aenean varius, quameu consectetur accumsan, magna urna volutpatdolor, nec rutrum orci tortor eu lectus. Curabiturquis tortor quis sapien venenatis vulputate at aerat. Nam a fringilla lacus, eu faucibus neque.Aliquam maximus, arcu et euismod ultrices, lacuspurus viverra quam, quis imperdiet magna erat utnisl. Aliquam a neque feugiat, vestibulum velitnec, molestie sapien."),
                  ),
                ],
              ),
            ));
          }
}
