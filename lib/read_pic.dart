import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'Manage/food_list.dart';
// import 'package:http/http.dart' as http;

class ReadJson extends StatefulWidget {
  @override
  _ReadJsonState createState() => _ReadJsonState();
}

// final fServerURL = "http://10.0.2.2:5000/";

class _ReadJsonState extends State<ReadJson> {
  final foodList = List<FoodList>();

  Future fetch() async {
    String jsonString = await rootBundle.loadString('json/FoodList.json');
    final response = json.decode(jsonString);
    final jsonFood = response["foods"];

    foodList.clear();
    jsonFood.forEach((e){
      foodList.add(FoodList.fromJson(e));
    });

  }
  //
  // File _image;
  // final picker = ImagePicker();
  //
  // Future _imgFromCamera() async {
  //   var image = await picker.getImage(source: ImageSource.camera);
  //
  //   setState(() {
  //     _image = File(image.path);
  //   });
  // }
  //
  // Future _imgFromGallery() async {
  //   var image = await picker.getImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     _image = File(image.path);
  //   });
  // }
  //
  // void _showPicker(context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SafeArea(
  //           child: Container(
  //             child: new Wrap(
  //               children: <Widget>[
  //                 new ListTile(
  //                     leading: new Icon(Icons.photo_library),
  //                     title: new Text('Photo Library'),
  //                     onTap: () {
  //                       _imgFromGallery();
  //                        Navigator.of(context).pop();
  //                     }),
  //                 new ListTile(
  //                   leading: new Icon(Icons.photo_camera),
  //                   title: new Text('Camera'),
  //                   onTap: () {
  //                     _imgFromCamera();
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //   );
  // }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(),
  //     body: Column(
  //       children: <Widget>[
  //         SizedBox(
  //           height: 32,
  //         ),
  //         Center(
  //           child: GestureDetector(
  //             onTap: () {
  //               _showPicker(context);
  //             },
  //             child: CircleAvatar(
  //               radius: 55,
  //               backgroundColor: Color(0xffFDCF09),
  //               child: _image != null
  //                   ? ClipRRect(
  //                 borderRadius: BorderRadius.circular(50),
  //                 child: Image.file(
  //                   _image,
  //                   width: 100,
  //                   height: 100,
  //                   fit: BoxFit.fitHeight,
  //                 ),
  //               )
  //                   : Container(
  //                 decoration: BoxDecoration(
  //                     color: Colors.grey[200],
  //                     borderRadius: BorderRadius.circular(50)),
  //                 width: 100,
  //                 height: 100,
  //                 child: Icon(
  //                   Icons.add,
  //                   color: Colors.grey[800],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  //
  @override
  Widget build(BuildContext) {
    return Scaffold (
      appBar : AppBar(
        title : Text('Open'),
      ),
      body : Center(
        child: RaisedButton(
          onPressed: () async{
            await fetch();
            print(foodList.toString());
          },
          child: Text('Show'),
        ),
      ),
    );
  }
}