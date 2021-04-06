import 'dart:convert';

import 'package:flutter/foundation.dart';

class Event {
  String id;
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;
  List<String> attendeeEmail;
  Event({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.startTime,
    @required this.endTime,
    @required this.attendeeEmail,
  });

  Event copyWith({
    String id,
    String title,
    String description,
    DateTime startTime,
    DateTime endTime,
    List<String> attendeeEmail,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      attendeeEmail: attendeeEmail ?? this.attendeeEmail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'attendeeEmail': attendeeEmail,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime']),
      attendeeEmail: List<String>.from(map['attendeeEmail']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Event(id: $id, title: $title, description: $description, startTime: $startTime, endTime: $endTime, attendeeEmail: $attendeeEmail)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Event &&
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      listEquals(other.attendeeEmail, attendeeEmail);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      attendeeEmail.hashCode;
  }
}

class AppEvent {
  final String userID;
  final String name;
  final String email;
  final String photoURL;
  final String description;
  final List<Event> events;
  AppEvent({
    @required this.userID,
    @required this.name,
    @required this.email,
    @required this.photoURL,
    @required this.description,
    @required this.events,
  });

  AppEvent copyWith({
    String userID,
    String name,
    String email,
    String photoURL,
    String  description,
    List<Event> events,
  }) {
    return AppEvent(
      userID: userID ?? this.userID,
      name: name ?? this.name,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      description: description ?? this.description,
      events: events ?? this.events,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'description': description,
      'events': events?.map((x) => x.toMap())?.toList(),
    };
  }

  factory AppEvent.fromMap(Map<String, dynamic> map) {
    return AppEvent(
      userID: map['userID'],
      name: map['name'],
      email: map['email'],
      photoURL: map['photoURL'],
      description: map['description'],
      events: List<Event>.from(map['events']?.map((x) => Event.fromMap(x))),
    );
  }
  factory AppEvent.fromDS(String id,Map<String, dynamic> map) {
    return AppEvent(
      userID: id,
      name: map['name'],
      email: map['email'],
      photoURL: map['photoURL'],
      description: map['description'],
      events: List<Event>.from(map['events']?.map((x) => Event.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppEvent.fromJson(String source) =>
      AppEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppEvent(userID: $userID, name: $name, email: $email, photoURL: $photoURL, description: $description, events: $events)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppEvent &&
        other.userID == userID &&
        other.name == name &&
        other.email == email &&
        other.photoURL == photoURL &&
        other.description == description &&
        listEquals(other.events, events);
  }

  @override
  int get hashCode {
    return userID.hashCode ^
        name.hashCode ^
        email.hashCode ^
        photoURL.hashCode ^
        description.hashCode ^
        events.hashCode;
  }
}
