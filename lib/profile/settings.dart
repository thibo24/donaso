import 'package:flutter/material.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/profile/profileActivity.dart';
import 'package:flutter_application_2/profile/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database.dart';
import '../navigationBar.dart';

class settings extends StatefulWidget {
  final User user;
  final Database db;
  final int selectedIndex;
  final Function(int) onItemSelected;

  settings(
      {Key? key,
        required this.user,
        required this.db,
        required this.selectedIndex,
        required this.onItemSelected})
      : super(key: key);

  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {

  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void navigateToLogin(){
    final loginMenu = MyApp(db: widget.db);
    Navigator.push(context, MaterialPageRoute(builder: (context) => loginMenu));
  }

  Future<void> deleteAccount(String username, BuildContext context) async {
    var confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer votre compte ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Non'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Oui'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      widget.db.deleteAccount(widget.user.username);
      clearSharedPreferences();
      navigateToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        user: widget.user,
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
                    'Settings',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.5,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.lightbulb,
                      color: Colors.grey,
                    ),
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeTrackColor: Colors.white,
                      activeColor: Colors.black,
                    ),
                    title: const Text('Dark mode'),
                    onTap: () {
                      // Change the app theme
                    },
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1.5,
                  ),
                  Container(
                    color: Colors.red,
                    child: ListTile(
                      title: const Text(
                        'DELETE ACCOUNT',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Icon(Icons.dangerous),
                      onTap: () {
                          deleteAccount(widget.user.username, context);
                      },
                    ),
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
