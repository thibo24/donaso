import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Widget> _tabs = [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.favorite),
    Icon(Icons.person),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Bottom Navigation Bar'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs,
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: _tabs.map((Widget tab) {
          return Tab(
            icon: tab,
          );
        }).toList(),
      ),
    );
  }
}

