import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_ver/Manage/constants.dart';
import 'package:flutter_demo_ver/read_pic.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_demo_ver/Manage/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class Tabless extends StatefulWidget {
  @override
  _TableList createState() {
    return _TableList();
  }
}

class _TableList extends State<Tabless> {
  Map<DateTime, List<Event>> selectedEvents;
  TextEditingController _eventController = TextEditingController();
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  // final fServerURL = "http://10.0.2.2:5000/";

  File _image;
  final picker = ImagePicker();

  Future _imgFromCamera() async {
    var image = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(image.path);
    });

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ReadJson()));
  }

  Future _imgFromGallery() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
    //
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ReadJson()));
  }

  @override
  void initState() {
    selectedEvents = {};
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.pop(context);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget taskList(String title, String description, BuildContext contexts) {
    Color datecolor = Colors.white;
    if(description.compareTo(DateFormat('yyyy-MM-dd').format(DateTime.now())) <= 0){
      datecolor = Colors.redAccent;
    }

    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: datecolor,
            size: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(contexts).size.width * 0.8,
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: (TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(description,
                    style: (TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("냉장고를 지켜라"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.camera_alt),
            onPressed: (){
              print("Camera on.");
              _showPicker(context);
        }),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('food').orderBy('foods',descending: false).snapshots(),//.orderBy('num',descending: false)
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildall(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildall(BuildContext context, List<DocumentSnapshot> snapshot){
    Size size = MediaQuery.of(context).size;

    List<Container> massageWis = [];
    DateTime days;
    selectedEvents = {};
    snapshot.forEach((doc) {
      final messageWi = taskList(doc["foods"]["Name"].toString(),doc["foods"]["ExpirationDate"].toString(),context);
      massageWis.add(messageWi);

      days = DateFormat('yyyy-MM-dd').parse(doc["foods"]["ExpirationDate"]);

      if (selectedEvents[days] != null) {
        selectedEvents[days].add(Event(
            title: doc["foods"]["Name"].toString(),id: doc.id));
      } else {
        selectedEvents[days] =
        [Event(title: doc["foods"]["Name"].toString(),id: doc.id)];
      }

    });

    return Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                TableCalendar<Event>(
                firstDay: DateTime.utc(1990),
                lastDay: DateTime.utc(2030),
                focusedDay: DateTime.now(),
                onDaySelected: (DateTime selectDay, DateTime focusDay){
                  setState(() {
                    selectedDay = selectDay;
                    focusedDay = focusDay;
                  });
                },
                selectedDayPredicate: (DateTime date){
                  return isSameDay(selectedDay,date);
                },
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(Icons.arrow_left),
                  rightChevronIcon: Icon(Icons.arrow_right),
                  titleTextStyle: const TextStyle(fontSize: 20.0),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  weekendTextStyle:
                  TextStyle(fontSize: 12).copyWith(color: Colors.red),
                  holidayTextStyle:
                  TextStyle(fontSize: 12).copyWith(color: Colors.red),
                ),

                locale: 'ko-KR',
                eventLoader: _getEventsfromDay
              ),..._getEventsfromDay(DateFormat('yyyy-MM-dd').parse(selectedDay.toString())).map((Event event) => ListTile(title: Text(event.title),
                onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("삭제하시겠습니까??"),
                  actions: [
                    TextButton(
                      child: Text("취소"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                        child: Text("확인"),
                        onPressed: () {
                          Navigator.pop(context);
                          FirebaseFirestore.instance.collection('food').doc(event.id).delete();
                          print("good");
                          setState(() {});
                          return;
                        }
                    )
                  ],
                ),
              ),)),
              SizedBox(height: size.height * 0.05),
              Container(
                padding: EdgeInsets.only(left: 30),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              "Today",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            )),
                        Column(
                          children: massageWis,
                        ),
                        /*
                        Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.length,
                                itemBuilder: (BuildContext context, int index){
                                  return taskList(snapshot.toString(), "hihihi", context);
                                })
                        ),*/

                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    kPrimaryColor.withOpacity(0),
                                    kPrimaryColor
                                  ],
                                  stops: [
                                    0.0,
                                    1.0
                                  ])),
                        )),
                    Positioned(
                      bottom: 30,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Add Event"),
                            content: TextFormField(
                              controller: _eventController,
                            ),
                            actions: [
                              TextButton(
                                child: Text("취소"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                  child: Text("확인"),
                                  onPressed: () {
                                    if (_eventController.text.isEmpty) {
                                    } else {
                                      /*
                                      if (selectedEvents[selectedDay] != null) {
                                        selectedEvents[selectedDay].add(Event(
                                            title: _eventController.text));
                                      } else {
                                        selectedEvents[selectedDay] =
                                        [Event(title: _eventController.text)];
                                      }
                                      */
                                    }
                                    Navigator.pop(context);
                                    if(_eventController.text.isNotEmpty){
                                      FirebaseFirestore.instance.collection('food').add(
                                          {'foods':{'ExpirationDate': DateFormat('yyyy-MM-dd').format(selectedDay),
                                            'Name': _eventController.text}});
                                    }
                                    setState(() {
                                    });
                                    _eventController.clear();
                                    return;
                                  }
                              )
                            ],
                          ),
                        ), child: Icon(Icons.add),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }
}