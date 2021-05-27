import 'package:flutter/cupertino.dart';

class Event{
  final String title;
  final String id;
  final String message;
  Event({@required this.title,
    @required this.id,
    @required this.message});

  String toString()=> this.title;
}