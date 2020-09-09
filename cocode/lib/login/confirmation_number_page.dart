import 'dart:convert';

import 'package:cocode/colors.dart';
import 'package:cocode/login/create_account_page.dart';
import 'package:cocode/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CertifyCodePage extends StatefulWidget {
  @override
  _CertifyCodePageState createState() => _CertifyCodePageState();
}

class _CertifyCodePageState extends State<CertifyCodePage> {
  final _key = GlobalKey<FormState>();
  String _number;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              TextFormField(
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: '인증번호',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return '인증번호를 입력해주세요';
                  }
                  return null;
                },
                onSaved: (newValue) => _number = newValue,
                keyboardType: TextInputType.number,
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      currentFocus.unfocus();
                      Navigator.pop(context);
                    },
                    child: Text('뒤로'),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (_key.currentState.validate()) {
                        _key.currentState.save();

                        _postRequest();
                      }
                    },
                    child: Text('완료'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: mainColor,
    );
  }

  _postRequest() async {
    String url = 'http://10.80.162.210:8080/users/signUp';

    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          'email': email.trim(),
          'certifyCode': _number.trim(),
        },
      ),
    );

    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
    if (data['status'] == 200) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    } else if (data['status'] == 401) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('인증번호 오류'),
            content: Text('인증번호가 일치하지 않습니다.'),
            actions: <Widget>[
              FlatButton(
                child: Text('확인'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        },
      );
    }
  }
}
