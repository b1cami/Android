import 'dart:convert';

import 'package:http/http.dart' as http;

class User {
  final int id;
  final String email;
  final String password;
  final String name;
  final String schoolNumber;
  final String image;
  final String certifyCode;
  final String token;
  final String mainUrl = 'http://10.80.162.210:8080';

  User(
      {this.id,
      this.email,
      this.password,
      this.name,
      this.schoolNumber,
      this.image,
      this.certifyCode,
      this.token});

  Future<List> getPosts() async {
    int index = 0;
    List testData = List();

    while (true) {
      String url = mainUrl + '/post/getPosts/$index';
      http.Response response = await http.get(url);

      var decodeData = utf8.decode(response.bodyBytes);
      var json = jsonDecode(decodeData);

      if (json['status'] != 200) {
        index--;
        break;
      } else {
        var data = json['posts'];
        testData.add(data);
        index++;
      }
    }

    List postData;
    if (index > 0) {
      postData = List.from(testData[0])..addAll(testData[index]);
    } else
      postData = testData[0];
    return postData;
  }

  Future<List> getLuches() async {
    int index = 0;
    List testData = List();

    while (true) {
      String url = mainUrl + '/lunch/getLunches/$index';
      http.Response response = await http.get(url);

      var decodeData = utf8.decode(response.bodyBytes);
      var json = jsonDecode(decodeData);

      if (json['status'] != 200) {
        index--;
        break;
      } else {
        var data = json['lunches'];
        testData.add(data);
        index++;
      }
    }
    List postData;
    if (index > 0) {
      postData = List.from(testData[0])..addAll(testData[index]);
    } else
      postData = testData[0];
    return postData;
  }

  getSchoolMenu() async {
    String url = mainUrl + '/lunch/getSchoolLunch';
    http.Response response = await http.get(url);

    var decodeData = utf8.decode(response.bodyBytes);
    var json = jsonDecode(decodeData);
    if (json['status'] == 200) {
      var list = [json['breakfast'], json['lunch'], json['dinner']];
      return list;
    } else {}
  }

  getPost(int postIndex) async {
    String url = user.mainUrl + '/post/getPost/$postIndex';
    http.Response response = await http.get(url);

    var decodeData = utf8.decode(response.bodyBytes);
    var json = jsonDecode(decodeData);
    return json['post'];
  }

  getLunch(int lunch) async {
    String url = user.mainUrl + '/lunch/getLunch/$lunch';
    http.Response response = await http.get(url);

    var decodeData = utf8.decode(response.bodyBytes);
    var json = jsonDecode(decodeData);
    return json['lunch'];
  }

  getCommnet(int index) async {
    String url = user.mainUrl + '/post/getComments/$index';
    http.Response response = await http.get(url);

    var decodeData = utf8.decode(response.bodyBytes);
    var json = jsonDecode(decodeData);
    return json['comments'];
  }

  getCommnetLunch(int index) async {
    String url = user.mainUrl + '/lunch/getComments/$index';
    http.Response response = await http.get(url);

    var decodeData = utf8.decode(response.bodyBytes);
    var json = jsonDecode(decodeData);
    return json['comments'];
  }
}

User user;
