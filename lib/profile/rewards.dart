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
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.grey,
                      backgroundImage:
                      AssetImage('assets/images/profilePicture/firstIcon.png'),
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
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(left: 20),
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.grey,
                          backgroundImage:
                          AssetImage('assets/images/profilePicture/firstIcon.png'),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(right: 20),
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.grey,
                          backgroundImage:
                          AssetImage('assets/images/profilePicture/firstIcon.png'),
                        ),
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
