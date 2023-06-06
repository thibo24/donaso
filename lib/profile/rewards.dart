import 'package:flutter/material.dart';
import 'package:flutter_application_2/profile/profileActivity.dart';
import 'package:flutter_application_2/profile/user.dart';
import '../database.dart';
import '../navigationBar.dart';

class rewards extends StatefulWidget {
  final User user;
  final Database db;
  final int selectedIndex;
  final Function(int) onItemSelected;

  rewards(
      {Key? key,
      required this.user,
      required this.db,
      required this.selectedIndex,
      required this.onItemSelected})
      : super(key: key);

  @override
  _rewardsState createState() => _rewardsState();
}

class _rewardsState extends State<rewards> {
  void reloadPage() {
    final rewardss = rewards(
        user: widget.user,
        db: widget.db,
        selectedIndex: widget.selectedIndex,
        onItemSelected: widget.onItemSelected);
    Navigator.push(context, MaterialPageRoute(builder: (context) => rewardss));
  }

  @override
  Widget build(BuildContext context) {
    bool hasEnoughPoints1 = widget.user.nbPoints >= 0;
    bool hasEnoughPoints2 = widget.user.nbPoints >= 5;
    bool hasEnoughPoints3 = widget.user.nbPoints >= 10;
    bool hasEnoughPoints4 = widget.user.nbPoints >= 15;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ],
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Image(
                      image: AssetImage(widget.user.image),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${widget.user.nbPoints} points",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(left: 20),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  hasEnoughPoints1 ? Colors.green : Colors.red,
                              backgroundImage: const AssetImage(
                                  'assets/images/profilePicture/firstIcon.png'),
                            ),
                          ),
                          onTap: () {
                            if (hasEnoughPoints1) {
                              setState(() {
                                widget.user.image =
                                    'assets/images/profilePicture/firstIcon.png';
                                widget.db.updateImage(widget.user,
                                    'assets/images/profilePicture/firstIcon.png');
                                reloadPage();
                              });
                            }
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(right: 20),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  hasEnoughPoints2 ? Colors.green : Colors.red,
                              backgroundImage: const AssetImage(
                                  'assets/images/profilePicture/secondIcon.png'),
                            ),
                          ),
                          onTap: () {
                            if (hasEnoughPoints2) {
                              setState(() {
                                widget.user.image =
                                    'assets/images/profilePicture/secondIcon.png';
                                widget.db.updateImage(widget.user,
                                    'assets/images/profilePicture/secondIcon.png');
                                reloadPage();
                              });
                            }
                          },
                        )
                      ]),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(left: 20),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                hasEnoughPoints3 ? Colors.green : Colors.red,
                            backgroundImage: const AssetImage(
                                'assets/images/profilePicture/thirdIcon.png'),
                          ),
                        ),
                        onTap: () {
                          if (hasEnoughPoints3) {
                            setState(() {
                              widget.user.image =
                                  'assets/images/profilePicture/thirdIcon.png';
                              widget.db.updateImage(widget.user,
                                  'assets/images/profilePicture/thirdIcon.png');
                              reloadPage();
                            });
                          }
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(right: 20),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                hasEnoughPoints4 ? Colors.green : Colors.red,
                            backgroundImage: const AssetImage(
                                'assets/images/profilePicture/fourthIcon.png'),
                          ),
                        ),
                        onTap: () {
                          if (hasEnoughPoints4) {
                            setState(() {
                              widget.user.image =
                                  'assets/images/profilePicture/fourthIcon.png';
                              widget.db.updateImage(widget.user,
                                  'assets/images/profilePicture/fourthIcon.png');
                              reloadPage();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
