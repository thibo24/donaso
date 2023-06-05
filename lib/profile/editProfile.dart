import 'package:flutter/material.dart';
import 'package:flutter_application_2/profile/profileActivity.dart';
import 'package:flutter_application_2/profile/user.dart';

import '../database.dart';
import '../navigationBar.dart';

class editProfile extends StatefulWidget {
  User user;
  final Database db;
  final int selectedIndex;
  final Function(int) onItemSelected;

  editProfile(
      {required this.user,
      required this.db,
      required this.selectedIndex,
      required this.onItemSelected});

  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  TextEditingController _field1Controller = TextEditingController();
  TextEditingController _field2Controller = TextEditingController();
  TextEditingController _field3Controller = TextEditingController();
  TextEditingController _field4Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _field1Controller.text = widget.user.username;
    _field2Controller.text = widget.user.email;
  }

  @override
  void dispose() {
    _field1Controller.dispose();
    _field2Controller.dispose();
    super.dispose();
  }

  void _saveChanges() {
    String newFieldValue1 = _field1Controller.text;
    String newFieldValue2 = _field2Controller.text;
    widget.user.username = newFieldValue1;
    widget.user.email = newFieldValue2;
    widget.db.updateAccount(widget.user);
    navigateToProfile();
  }

  void navigateToProfile() {
    final loginMenu = profileActivity(
      database: widget.db,
      selectedIndex: widget.selectedIndex,
      onPageSelected: widget.onItemSelected,
      user: widget.user,
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => loginMenu));
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: widget.selectedIndex,
        onItemSelected: widget.onItemSelected,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                    'Edit Profile',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _field1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  TextFormField(
                    controller: _field2Controller,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    child: Text('Save changes'),
                    onPressed: _saveChanges,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
