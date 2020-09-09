import 'package:cocode/profile_screens/user_profile.dart';
import 'package:cocode/user_data.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('내 프로필'),
          ListTile(
            leading: Icon(
              Icons.account_circle,
            ),
            title: Text(
              user.name,
            ),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage())),
          ),
          Divider(
            thickness: 3,
          ),
          Text('태그'),
          Expanded(
            child: ListView.builder(itemBuilder: (context, int index) {
              return ListTile(
                leading: Icon(
                  Icons.account_circle,
                ),
                title: Text('TEST'),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage())),
              );
            }),
          ),
        ],
      ),
    );
  }
}
