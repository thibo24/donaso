import 'package:flutter/material.dart';
import 'package:flutter_application_2/profile/dataPrivacy.dart';
import 'package:flutter_application_2/profile/settings.dart';
import 'package:flutter_application_2/profile/user.dart';
import 'package:social_share/social_share.dart';
import '../database.dart';
import '../navigationBar.dart';

class profileActivity extends StatefulWidget {
  late Database database;
  final int selectedIndex;
  final Function(int) onPageSelected; // Callback function
  final User user;
  profileActivity(
      {required this.database,
      required this.selectedIndex,
      required this.onPageSelected,
      required this.user});

  @override
  _profileActivityState createState() => _profileActivityState();
}


class _profileActivityState extends State<profileActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: widget.selectedIndex,
          onItemSelected: widget.onPageSelected,
        ),
        backgroundColor: Colors.white,
        body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white30,
                      backgroundImage: AssetImage(
                          'assets/images/profilePicture/firstIcon.png'),
                    ),
                  ),
                  Column(children: [
                    Text(
                      widget.user.username,
                      style: const TextStyle(fontSize: 20),
                      selectionColor: Colors.black,
                    ),
                    Text('${widget.user.nbPoints} points'),
                  ]),
                ]),
                const SizedBox(height: 20),
                Expanded(
                    child: ListView(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    ListTile(
                      leading: Image.asset("assets/images/reward.png"),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.green,
                      ),
                      title: const Text(
                        "Rewards",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      // onTap: () => redirect to reward page
                    ),
                    const Divider(
                      color: Colors.grey, // Couleur de la démarcation
                      thickness: 1.5, // Épaisseur de la démarcation
                    ),
                    ListTile(
                      leading: Image.asset("assets/images/twitter.png"),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        "Share on Tweeter",
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      onTap: () {
                        SocialShare.shareTwitter("Hello world");
                      },
                    ),
                    const Divider(
                      color: Colors.grey, // Couleur de la démarcation
                      thickness: 1.5, // Épaisseur de la démarcation
                    ),
                    ListTile(
                      leading: Image.asset("assets/images/facebook.png"),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blueAccent,
                      ),
                      title: const Text(
                        "Share on Facebook",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () => {
                      SocialShare.shareWhatsapp("Hello world"),
                      },
                    ),
                    const Divider(
                      color: Colors.grey, // Couleur de la démarcation
                      thickness: 1.5, // Épaisseur de la démarcation
                    ),
                    ListTile(
                      leading: Image.asset("assets/images/edit.png"),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Edit profile",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      // onTap: () => redirect to edit profile
                    ),
                    const Divider(
                      color: Colors.grey, // Couleur de la démarcation
                      thickness: 1.5, // Épaisseur de la démarcation
                    ),
                    ListTile(
                      leading: Image.asset("assets/images/settings.png"),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Settings",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => settings(user: widget.user, db: widget.database, selectedIndex: widget.selectedIndex, onItemSelected: widget.onPageSelected)),
                      )
                    ),
                    const Divider(
                      color: Colors.grey, // Couleur de la démarcation
                      thickness: 1.5, // Épaisseur de la démarcation
                    ),
                    ListTile(
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
                      title: const Text(
                        "Data Privacy",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => dataPrivacy(user: widget.user, db: widget.database, selectedIndex: widget.selectedIndex, onItemSelected: widget.onPageSelected)),
                        )
                    ),
                    const Divider(
                      color: Colors.grey, // Couleur de la démarcation
                      thickness: 1.5, // Épaisseur de la démarcation
                    ),
                    const ListTile(
                      trailing: Icon(
                        Icons.exit_to_app,
                        color: Colors.redAccent,
                      ),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),

                    ),
                  ],
                ))
              ],
            )));
  }
}
