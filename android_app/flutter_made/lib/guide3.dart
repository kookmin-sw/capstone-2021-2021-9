import 'package:flutter/material.dart';
import 'package:flutter_made/constants.dart';
import 'package:flutter_made/main_page.dart';

class Guide3 extends StatelessWidget{
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
                  child: Image.asset(
                "assets/images/guide3.png",
                width: size.width*0.8,
              )),
              Positioned(
                  bottom: 120,
                  child: Text("가이드 페이지3", textAlign: TextAlign.center, style: TextStyle(fontWeight:  FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white)
                ,)
              ),
              Positioned(
                bottom: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(29),
                  child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 80),
                      color: kPrimaryColor,
                      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return Scaffold(backgroundColor: Color(
                          0xffa05fd9), body: Main_page(),);
                      })
                      );},child: Text("Next",style: TextStyle(color: Colors.white),
                  )),
                ),
              )
            ]
        )



    );
  }
}