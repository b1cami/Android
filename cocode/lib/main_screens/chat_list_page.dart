import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.chat_bubble),
          title: Text('TEST'),
        );
      }),
    );
  }
}
