import 'dart:convert';

import 'package:cocode/colors.dart';
import 'package:cocode/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _foodNameNode = FocusNode();
final _descriptionNode = FocusNode();

class AddInquiredPage extends StatefulWidget {
  @override
  _AddInquiredPageState createState() => _AddInquiredPageState();
}

class _AddInquiredPageState extends State<AddInquiredPage> {
  final _key = GlobalKey<FormState>();
  String _foodName;
  String _description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          '문의 넣기',
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

                String url = user.mainUrl + '/lunch/upload';

                http.Response response = await http.post(
                  url,
                  headers: {
                    'Content-Type': 'application/json',
                    'Token': user.token,
                  },
                  body: jsonEncode(
                    <String, String>{
                      'foodName': _foodName,
                      'description': _description
                    },
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
                focusNode: _foodNameNode,
                onFieldSubmitted: (value) {
                  _foodNameNode.unfocus();
                  FocusScope.of(context).requestFocus(_descriptionNode);
                },
                decoration: InputDecoration(labelText: '음식'),
                maxLength: 100,
                validator: (value) {
                  if (value.isEmpty) {
                    return '음식을 입력해주세요';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) => _foodName = newValue,
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: TextFormField(
                  focusNode: _descriptionNode,
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
                  onSaved: (newValue) => _description = newValue,
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
