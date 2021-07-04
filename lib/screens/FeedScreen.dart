import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/screens/HomeScreen.dart';
import 'package:twitter_clone/screens/NotificationScreen.dart';
import 'package:twitter_clone/screens/ProfileScreen.dart';
import 'package:twitter_clone/screens/SearchScreen.dart';

class FeedScreen extends StatefulWidget {
  final String? currentUserId;

  const FeedScreen({Key? key, this.currentUserId}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomeScreen(
          currentUserId: widget.currentUserId!,
        ),
        SearchScreen(
          currentUserId: widget.currentUserId,
        ),
        NotificationScreen(
          currentUserId: widget.currentUserId!,
        ),
        ProfileScreen(
          currentUserId: widget.currentUserId,
          visitedUserId: widget.currentUserId,
        ),
      ].elementAt(_selectedTab),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        activeColor: KTweeterColor,
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
