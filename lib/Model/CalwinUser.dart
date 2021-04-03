import 'dart:convert';
import 'package:calwin/Model/CalwinEvent.dart';
import 'package:flutter/material.dart';

class CalwinUser {
  final String userId;
  final String name;
  final List<CalwinEvent> events;

  // TODO: Add List of Attendees
  CalwinUser({
    this.events,
    this.userId,
    this.name
  });

  CalwinUser copyWith({
    String name,
    List<CalwinEvent> events,
  }) {
    return CalwinUser(
      events: events ?? this.events,
      name: name ?? this.name,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'events': events,
      'name' : name,
    };
  }

  factory CalwinUser.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CalwinUser(
      events: map['events'],
      name: map['name'],
    );
  }
  factory CalwinUser.fromDS(String id, Map<String, dynamic> data) {
    if (data == null) return null;

    return CalwinUser(
      events: data['events'],
      name: data['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CalwinUser.fromJson(String source) =>
      CalwinUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CalwinEvent(title: $title, id: $id, description: $description, date: $date, userId: $userId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CalwinUser &&
        o.title == title &&
        o.id == id &&
        o.description == description &&
        o.date == date &&
        o.userId == userId;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        id.hashCode ^
        description.hashCode ^
        date.hashCode ^
        userId.hashCode;
  }
}
