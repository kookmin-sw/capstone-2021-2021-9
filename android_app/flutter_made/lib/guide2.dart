import 'package:flutter/material.dart';
import 'package:flutter_made/constants.dart';
import 'package:flutter_made/guide3.dart';

class Guide2 extends StatelessWidget{
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
                "assets/images/guide2.png",
                width: size.width*0.8,
              )),
              Positioned(
                  bottom: 120,
                  child: Text("가이드 페이지2", textAlign: TextAlign.center, style: TextStyle(fontWeight:  FontWeight.bold,
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
                      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return Scaffold(body: Guide3(),);
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