import 'package:cocode/colors.dart';
import 'package:cocode/main_screens/chat_list_page.dart';
import 'package:cocode/community/community_page.dart';
import 'package:cocode/main_screens/home_page.dart';
import 'package:cocode/main_screens/setting_page.dart';
import 'package:cocode/profile_screens/user_list_page.dart';
import 'package:flutter/material.dart';

int _index = 0;
List _pages = [HomePage(), ChatListPage(), CommunityPage(), SettingPage()];
List _titles = ['홈', '채팅방', '커뮤니티', '설정'];

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
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: mainColor,
        onTap: onTapped,
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(
            title: Text('주소록'),
            icon: Icon(Icons.account_circle),
          ),
          BottomNavigationBarItem(
            title: Text('채팅'),
            icon: Icon(Icons.message),
          ),
          BottomNavigationBarItem(
            title: Text('채팅'),
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
