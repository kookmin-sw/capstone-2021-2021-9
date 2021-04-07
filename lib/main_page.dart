import 'package:flutter/material.dart';
import 'package:flutter_made/constants.dart';
import 'package:flutter_made/guide2.dart';
import 'package:table_calendar/table_calendar.dart';

class Main_page extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  child: TableCalendar(
                firstDay: DateTime.utc(2010, 10,16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
              )),
              Positioned(
                bottom: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 120),
                      color: Color(0xff3ba7c7),
                      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return Scaffold(backgroundColor: Color(
                          0xffa05fd9), body: Main_page(),);
                      })
                      );},child: Text("오리 훈제\n4월 14일 까지",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),
                  )),
                ),
              ),Positioned(
                bottom: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 120),
                      color: Color(0xff3ba7c7),
                      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return Scaffold(backgroundColor: Color(
                          0xffa05fd9), body: Main_page(),);
                      })
                      );},child: Text("서울 우유\n4월 28일 까지",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              Positioned(
                  bottom: 80,
                  child: Text("메인 페이지", textAlign: TextAlign.center, style: TextStyle(fontWeight:  FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white)
                ,))
            ]
        )



    );
  }
}