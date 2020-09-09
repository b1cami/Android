import 'package:cocode/colors.dart';
import 'package:cocode/school_inquired/school_inquired_page.dart';
import 'package:cocode/user_data.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Card(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      size: 150,
                    ),
                    Text(user.name),
                    Text(user.email)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text('오늘의 급식'),
              Expanded(
                child: Container(),
              ),
              RaisedButton(
                color: mainColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text('급식 건의'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InquiredPage(),
                      ));
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var breakfast = snapshot.data[0];
                var lunch = snapshot.data[1];
                var dinner = snapshot.data[1];
                return Row(
                  children: <Widget>[
                    Card(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height / 4,
                          child: Column(
                            children: <Widget>[
                              Text('아침'),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: breakfast.length,
                                  itemBuilder: (context, index) {
                                    return Text(breakfast[index]);
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Card(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height / 4,
                          child: Column(
                            children: <Widget>[
                              Text('점심'),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: lunch.length,
                                  itemBuilder: (context, index) {
                                    return Text(lunch[index]);
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Card(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height / 4,
                          child: Column(
                            children: <Widget>[
                              Text('저녁'),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: dinner.length,
                                  itemBuilder: (context, index) {
                                    return Text(dinner[index]);
                                  },
                                ),
                              ),
                            ],
                          )),
                    )
                  ],
                );
              } else
                return Text('급식을 가져올 수 없습니다.');
            },
            future: user.getSchoolMenu(),
          )
        ],
      ),
    );
  }
}
