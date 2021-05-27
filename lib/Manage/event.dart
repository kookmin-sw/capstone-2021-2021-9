import 'package:flutter/cupertino.dart';

class Event{
  final String title;
  final String id;
  Event({@required this.title,
    @required this.id});

  String toString()=> this.title;
}