import 'dart:convert';

import 'package:cocode/colors.dart';
import 'package:cocode/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

int lunchIndex = 0;

class InquireViewPage extends StatefulWidget {
  @override
  _InquireViewPageState createState() => _InquireViewPageState();
}

class _InquireViewPageState extends State<InquireViewPage> {
  final myController = TextEditingController();
  final _key = GlobalKey<FormState>();
  String _commet;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: user.getLunch(lunchIndex),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(data['foodName'], style: TextStyle(color: black)),
              backgroundColor: white,
              elevation: 0.0,
              iconTheme: IconThemeData(color: black),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {});
                  },
                )
              ],
            ),
            body: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('작성자 - ${data['uploader']}'),
                        Text('시간 - ${data['upload']}'),
                        SingleChildScrollView(child: Text(data['description'])),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Form(
                      key: _key,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  controller: myController,
                                  onSaved: (newValue) => _commet = newValue,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return '댓글을 입력해주세요';
                                    } else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: '댓글 쓰기',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () async {
                                  if (_key.currentState.validate()) {
                                    _key.currentState.save();
                                    myController.clear();
                                    String url =
                                        user.mainUrl + '/lunch/comment';

                                    http.Response response = await http.post(
                                      url,
                                      headers: {
                                        'Content-Type': 'application/json',
                                        'Token': user.token
                                      },
                                      body: jsonEncode(
                                        <String, dynamic>{
                                          'comment': _commet.trim(),
                                          'lunchId': lunchIndex
                                        },
                                      ),
                                    );

                                    var decodeData =
                                        utf8.decode(response.bodyBytes);
                                    var json = jsonDecode(decodeData);
                                    if (json['status'] == 200) {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      currentFocus.unfocus();
                                      setState(() {});
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                          FutureBuilder(
                            future: user.getCommnetLunch(lunchIndex),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Expanded(
                                  child: ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      var data = snapshot.data[index];
                                      String time = uploadDateTime(
                                          DateTime.parse(data['upload']));

                                      return ListTile(
                                        leading: Text(data['userName']),
                                        title: Text(data['comment']),
                                        subtitle: Text(time,
                                            style:
                                                TextStyle(color: Colors.blue)),
                                        trailing: isMyComment(
                                            data['userName'], data['id']),
                                      );
                                    },
                                  ),
                                );
                              } else
                                return Container();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: white,
          );
        } else
          return Container(
            child: null,
          );
      },
    );
  }

  isMyComment(String name, int index) {
    if (user.name == name) {
      return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          String url = user.mainUrl + '/lunch/deleteComment/$index';
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
