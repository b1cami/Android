import 'package:cocode/colors.dart';
import 'package:cocode/community/community_page.dart';
import 'package:cocode/main_screens/home_page.dart';
import 'package:cocode/main_screens/setting_page.dart';
import 'package:flutter/material.dart';

int _index = 0;
List _pages = [HomePage(), CommunityPage(), SettingPage()];
List _titles = ['홈', '커뮤니티', '설정'];

class TapPage extends StatefulWidget {
  @override
  _TapPageState createState() => _TapPageState();
}

class _TapPageState extends State<TapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          _titles[_index],
          style: TextStyle(color: black),
        ),
        elevation: 0.0,
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: white,
        onTap: onTapped,
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(
            title: Text('홈'),
            icon: Icon(Icons.account_circle),
          ),
          BottomNavigationBarItem(
            title: Text('커뮤니티'),
            icon: Icon(Icons.assignment),
          ),
          BottomNavigationBarItem(
            title: Text('설정'),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      backgroundColor: white,
    );
  }

  void onTapped(int value) {
    setState(() {
      _index = value;
    });
  }
}
