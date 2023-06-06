import 'package:flutter/material.dart';
import 'package:flutter_application_2/profile/dataPrivacy.dart';
import 'package:flutter_application_2/profile/rewards.dart';
import 'package:flutter_application_2/profile/settings.dart';
import 'package:flutter_application_2/profile/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_share/social_share.dart';
import '../database.dart';
import '../main.dart';
import '../navigationBar.dart';
import 'editProfile.dart';

class profileActivity extends StatefulWidget {
  late Database database;
  final int selectedIndex;
  final Function(int) onPageSelected;
  final User user;
  String point = "";

  profileActivity(
      {required this.database,
      required this.selectedIndex,
      required this.onPageSelected,
      required this.user});

  @override
  _profileActivityState createState() => _profileActivityState();
}

class _profileActivityState extends State<profileActivity> {
  Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void navigateToLogin() {
    final loginMenu = MyApp();
    Navigator.push(context, MaterialPageRoute(builder: (context) => loginMenu));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          user: widget.user,
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
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white30,
                      backgroundImage: AssetImage(
                          widget.user.image),
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
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => rewards(
                                  user: widget.user,
                                  db: widget.database,
                                  selectedIndex: widget.selectedIndex,
                                  onItemSelected: widget.onPageSelected)),
                        )
                      },
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => editProfile(
                                    user: widget.user,
                                    db: widget.database,
                                    selectedIndex: widget.selectedIndex,
                                    onItemSelected: widget.onPageSelected)),
                          );
                        }),
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
                              MaterialPageRoute(
                                  builder: (context) => settings(
                                      user: widget.user,
                                      db: widget.database,
                                      selectedIndex: widget.selectedIndex,
                                      onItemSelected: widget.onPageSelected)),
                            )),
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
                              MaterialPageRoute(
                                  builder: (context) => dataPrivacy(
                                      user: widget.user,
                                      db: widget.database,
                                      selectedIndex: widget.selectedIndex,
                                      onItemSelected: widget.onPageSelected)),
                            )),
                    const Divider(
                      color: Colors.grey, // Couleur de la démarcation
                      thickness: 1.5, // Épaisseur de la démarcation
                    ),
                    ListTile(
                      trailing: const Icon(
                        Icons.exit_to_app,
                        color: Colors.redAccent,
                      ),
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                      onTap: () {
                        clearSharedPreferences();
                        navigateToLogin();
                      },
                    ),
                  ],
                ))
              ],
            )));
  }
}
