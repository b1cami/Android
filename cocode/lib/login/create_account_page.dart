import 'dart:convert';

import 'package:cocode/colors.dart';
import 'package:cocode/login/confirmation_number_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String email;
final _nameNode = FocusNode();
final _emailNode = FocusNode();
final _passwordNode = FocusNode();
final _rePasswordNode = FocusNode();

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _key = GlobalKey<FormState>();
  String _name;
  String _password;
  String _checkPassword;
  bool _buttonShow1 = true;
  bool _buttonShow2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Form(
        key: _key,
        child: Container(
          margin: EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  focusNode: _nameNode,
                  onFieldSubmitted: (value) {
                    _nameNode.unfocus();
                    FocusScope.of(context).requestFocus(_emailNode);
                  },
                  decoration: InputDecoration(labelText: '이름'),
                  maxLength: 100,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return '이름을 입력해주세요.';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) {
                    _name = newValue;
                  },
                ),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    focusNode: _emailNode,
                    onFieldSubmitted: (value) {
                      _emailNode.unfocus();
                      FocusScope.of(context).requestFocus(_passwordNode);
                    },
                    decoration: InputDecoration(
                      labelText: '이메일',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 320,
                    validator: (String value) {
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
                    onSaved: (newValue) => email = newValue),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  focusNode: _passwordNode,
                  onFieldSubmitted: (value) {
                    _passwordNode.unfocus();
                    FocusScope.of(context).requestFocus(_rePasswordNode);
                  },
                  obscureText: _buttonShow1,
                  maxLength: 25,
                  decoration: InputDecoration(
                      labelText: '비밀번호',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _buttonShow1 = !_buttonShow1;
                          });
                        },
                        child: Icon(_buttonShow1
                            ? Icons.visibility
                            : Icons.visibility_off),
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    } else if (value.length < 8) {
                      return '8자 이상으로 적어주세요';
                    } else {
                      _checkPassword = value;
                      return null;
                    }
                  },
                ),
                TextFormField(
                  focusNode: _rePasswordNode,
                  maxLength: 25,
                  obscureText: _buttonShow2,
                  decoration: InputDecoration(
                      labelText: '비밀번호 재입력',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _buttonShow2 = !_buttonShow2;
                          });
                        },
                        child: Icon(_buttonShow2
                            ? Icons.visibility
                            : Icons.visibility_off),
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    } else if (value != _checkPassword) {
                      return '비밀번호가 일치하지 않습니다.';
                    } else if (value.length < 8) {
                      return '8자 이상으로 적어주세요';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newValue) => _password = newValue,
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
      ),
    );
  }

  _postRequest() async {
    String url = 'http://10.80.162.210:8080/users/sendEmail';

    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, String>{
          'email': email.trim(),
          'password': _password.trim(),
          'name': _name.trim(),
        },
      ),
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (data['status'] == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CertifyCodePage()));
    }
  }
}
