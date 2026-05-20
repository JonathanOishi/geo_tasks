import 'package:flutter/material.dart';

class Task {
  String uid;
  String title;
  DateTime date;
  TimeOfDay time;
  String? location;
  bool isCompleted;

  Task({
    required this.uid,
    required this.title,
    required this.date,
    required this.time,
    this.location,
    this.isCompleted = false,
  });
}
