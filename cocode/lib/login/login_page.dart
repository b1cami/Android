import 'dart:convert';

import 'package:cocode/colors.dart';
import 'package:cocode/login/create_account_page.dart';
import 'package:cocode/tap_page.dart';
import 'package:cocode/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _idNode = FocusNode();
final _passwordNode = FocusNode();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  String _email;
  String _password;
  bool _buttonShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/CoCodeLogo.png'),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  focusNode: _idNode,
                  onFieldSubmitted: (value) {
                    _idNode.unfocus();
                    FocusScope.of(context).requestFocus(_passwordNode);
                  },
                  maxLength: 320,
                  decoration: InputDecoration(
                    hintText: '아이디',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '이메일을 입력해주세요.';
                    } else if (!RegExp(
                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                        .hasMatch(value)) {
                      return '올바른 이메일을 입력해주세요';
                    }
                    {
                      return null;
                    }
                  },
                  onSaved: (newValue) => _email = newValue,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: _buttonShow,
                  maxLength: 25,
                  focusNode: _passwordNode,
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _buttonShow = !_buttonShow;
                        });
                      },
                      child: Icon(_buttonShow
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '비밀번호를 입력해주세요';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _password = newValue,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      if (_key.currentState.validate()) {
                        _key.currentState.save();
                        _postRequest();
                      }
                    },
                    color: mainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Text('로그인'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '계정이 없으신가요?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateAccountPage())),
                      child: Text('가입하기'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _postRequest() async {
    String url = 'http://10.80.162.210:8080/users/login';

    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{'email': _email.trim(), 'password': _password.trim()},
      ),
    );

    var decodeData = utf8.decode(response.bodyBytes);
    var json = jsonDecode(decodeData);
    if (json['status'] == 200) {
      Map<String, dynamic> data = json['user'];
      print(json);

      user = User(
        id: data['id'],
        email: data['email'],
        password: data['password'],
        name: data['name'],
        schoolNumber: data['schoolNumber'],
        image: data['image'],
        certifyCode: data['certifyCode'],
        token: json['token'],
      );

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => TapPage()), (route) => false);
    } else if (json['status'] == 400) {
      show('회원 없음', '회원가입을 해주세요');
    } else if (json['status'] == 401) {
      show('로그인 오류', '비밀번호를 확인해주세요');
    }
  }

  show(String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
