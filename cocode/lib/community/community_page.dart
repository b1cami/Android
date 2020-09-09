import 'dart:convert';

import 'package:cocode/colors.dart';
import 'package:cocode/community/add_post_page.dart';
import 'package:cocode/community/post_view_page.dart';
import 'package:cocode/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: Container(
          margin: EdgeInsets.all(10),
          child: RefreshIndicator(
            onRefresh: _onRefreshed,
            child: FutureBuilder(
              future: user.getPosts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, int index) {
                              var json = snapshot.data[index];
                              String date = uploadDateTime(
                                  DateTime.parse(json['upload']));
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text('${json['title']}'),
                                      subtitle: Text(json['content']),
                                      trailing: isMyPost(
                                          json['uploader'], json['id']),
                                      onTap: () {
                                        postIndex = json['id'];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PostViewPage()));
                                      },
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: Text(date,
                                          style: TextStyle(color: Colors.blue)),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SingleChildScrollView(child: Text('게시글이 없습니다.'));
                }
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPostPage(),
              ),
            );

            setState(() {});
          },
          child: Icon(Icons.add),
        ));
  }

  Future<void> _onRefreshed() async {
    setState(() {});
  }

  isMyPost(String name, int index) {
    if (user.name == name) {
      return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          String url = user.mainUrl + '/post/delete/$index';
          http.Response response = await http.delete(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
          );
          var json = jsonDecode(response.body);
          if (json['status'] == 200) {
            setState(() {});
          }
        },
      );
    } else {
      return null;
    }
  }

  uploadDateTime(DateTime dateTime) {
    String time = '분 전';
    int date = DateTime.now().difference(dateTime).inMinutes;

    if (date > 56) {
      date = date ~/ 60;
      time = '시간 전';
    }
    return '$date' + time;
  }
}
