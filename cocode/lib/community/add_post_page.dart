import 'dart:convert';

import 'package:cocode/colors.dart';
import 'package:cocode/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _titleNode = FocusNode();
final _contentNode = FocusNode();

class AddPostPage extends StatelessWidget {
  final _key = GlobalKey<FormState>();
  String _title;
  String _content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          '글쓰기',
          style: TextStyle(color: black),
        ),
        iconTheme: IconThemeData(color: black),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton(
            child: Text('완료'),
            onPressed: () async {
              if (_key.currentState.validate()) {
                _key.currentState.save();

                String url = user.mainUrl + '/post/upload';

                http.Response response = await http.post(
                  url,
                  headers: {
                    'Content-Type': 'application/json',
                    'Token': user.token,
                  },
                  body: jsonEncode(
                    <String, String>{'title': _title, 'content': _content},
                  ),
                );

                var json = jsonDecode(response.body);
                if (json['status'] == 200) {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  currentFocus.unfocus();
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _key,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextFormField(
                focusNode: _titleNode,
                onFieldSubmitted: (value) {
                  _titleNode.unfocus();
                  FocusScope.of(context).requestFocus(_contentNode);
                },
                decoration: InputDecoration(labelText: '제목'),
                maxLength: 100,
                validator: (value) {
                  if (value.isEmpty) {
                    return '제목을 입력해주세요';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) => _title = newValue,
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: TextFormField(
                  focusNode: _contentNode,
                  maxLines: 10000,
                  decoration: InputDecoration(
                    labelText: '내용',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 10000,
                  validator: (value) {
                    if (value.isEmpty) {
                      return '내용을 입력해주세요';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) => _content = newValue,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: white,
    );
  }
}
