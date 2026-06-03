import 'package:flutter/material.dart';

class Task {
  final String uid;
  final String title;
  final DateTime date;
  final TimeOfDay time;
  final String? location;
  final double? latitude;
  final double? longitude;
  final bool isCompleted;

  const Task({
    required this.uid,
    required this.title,
    required this.date,
    required this.time,
    this.location,
    this.latitude,
    this.longitude,
    this.isCompleted = false,
  });

  Task copyWith({
    String? uid,
    String? title,
    DateTime? date,
    TimeOfDay? time,
    String? location,
    double? latitude,
    double? longitude,
    bool? isCompleted,
  }) {
    return Task(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  String get dateLabel =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';

  String get timeLabel =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String get statusLabel => isCompleted ? 'Concluida' : 'Pendente';

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'date': date.toIso8601String(),
      'timeHour': time.hour,
      'timeMinute': time.minute,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      uid: json['uid'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      time: TimeOfDay(
        hour: json['timeHour'] as int,
        minute: json['timeMinute'] as int,
      ),
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
