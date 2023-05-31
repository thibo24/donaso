import 'package:flutter/material.dart';
import 'package:flutter_application_2/profile/profileActivity.dart';
import 'package:flutter_application_2/profile/user.dart';
import '../database.dart';
import '../navigationBar.dart';

class dataPrivacy extends StatefulWidget {
  final User user;
  final Database db;
  final int selectedIndex;
  final Function(int) onItemSelected;
  late Future<String> _dataPrivacyFuture;

  dataPrivacy({
    required this.user,
    required this.db,
    required this.selectedIndex,
    required this.onItemSelected,
  }) {
    _dataPrivacyFuture = _getDataPrivacy();
  }

  Future<String> _getDataPrivacy() async {
    try {
      return await db.getPrivacyConditions();
    } catch (error) {
      print('Failed to get privacy details: $error');
      return Future.error('Failed to get privacy details');
    }
  }

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
      body: FutureBuilder<String>(
        future: widget._dataPrivacyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    widget._dataPrivacyFuture = widget._getDataPrivacy();
                  });
                },
                child: const Text('Failed to load categories. Retry'),
              ),
            );
          } else {
            final dataPrivacy = snapshot.data!;
            return Container(
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
                  Expanded(
                    child: Text(dataPrivacy),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
