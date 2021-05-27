import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_demo_ver/table_list.dart';
import 'Manage/food_list.dart';
import 'package:http/http.dart' as http;

class ReadJson extends StatefulWidget {
  @override
  _ReadJsonState createState() => _ReadJsonState();
}

class _ReadJsonState extends State<ReadJson> {
  final fList = List<FoodList>();
  var isLoading = true;
  
  Future fetch() async {
    setState(() {
      isLoading = true;
    });

    var fServerURL = Uri.parse('http://10.0.2.2:5000/');

    var response = await http.get(fServerURL);

    final jsonResult = jsonDecode(utf8.decode(response.bodyBytes));
    final jsonFood = jsonResult['foods'];

    setState(() {
      fList.clear();
      jsonFood.forEach((e){
        fList.add(FoodList.fromJson(e));
      });
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('새로 추가된 항목'),
      ),
      body: isLoading
          ? _LoadingWidget()
          : _MakeListWidget()
    );
  }

  Widget _MakeListWidget() {
    return ListView(
      children: fList.map((e) {
        return ListTile(
            title : Text(e.name),
            subtitle: Text(e.expirationDate));
      }).toList(),
    );
  }

  Widget _LoadingWidget() {
    return Center(
      child : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('영수증에서 식품만 불러오는 중입니다.', style: TextStyle(
              fontSize: 20, fontWeight : FontWeight.bold),
          ),
          Text(' ', style: TextStyle(
              fontSize: 40, fontWeight : FontWeight.bold),
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
