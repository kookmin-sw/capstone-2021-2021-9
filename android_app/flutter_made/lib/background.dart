import 'package:flutter/material.dart';
import 'package:flutter_made/constants.dart';
import 'package:flutter_made/guide1.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 60,
              child: Text("냉장고를 지켜라\n방치되는 재료가 없도록", textAlign: TextAlign.center, style: TextStyle(fontWeight:  FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white),),),
            Positioned(
                child: Image.asset(
                  "assets/images/hello.png",
                  width: size.width*0.8,
                )),
      Positioned(
        bottom: 80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(29),
          child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 80),
              color: kPrimaryColor,
              onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return Scaffold(body: Guide1(),);
              })
              );},child: Text("Start",style: TextStyle(color: Colors.white),
          )),
        ),
      ),
            child,
          ],
        )
    );
  }
}