import 'dart:convert';

import 'package:cocode/colors.dart';
import 'package:cocode/school_inquired/add_inquired_page.dart';
import 'package:cocode/school_inquired/inquire_view_page.dart';
import 'package:cocode/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InquiredPage extends StatefulWidget {
  @override
  _InquiredPageState createState() => _InquiredPageState();
}

class _InquiredPageState extends State<InquiredPage> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          '급식 건의',
          style: TextStyle(color: black),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: black),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: _onRefreshed,
          child: FutureBuilder(
            future: user.getLuches(),
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
                            String date =
                                uploadDateTime(DateTime.parse(json['upload']));
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  ListTile(
                                    title: Text(json['foodName']),
                                    subtitle: Text(json['description']),
                                    trailing:
                                        isMyPost(json['uploader'], json['id']),
                                    onTap: () {
                                      lunchIndex = json['id'];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InquireViewPage()));
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
              builder: (context) => AddInquiredPage(),
            ),
          );

          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _onRefreshed() async {
    setState(() {});
  }

  isMyPost(String name, int index) {
    if (user.name == name) {
      return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          String url = user.mainUrl + '/lunch/delete/$index';
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
