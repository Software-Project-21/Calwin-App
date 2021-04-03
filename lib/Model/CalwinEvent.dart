import 'package:flutter/material.dart';

class CalwinEvent {
  final String eventid;
  final String name;
  final String description;
  final String meetlink;
  final List<dynamic> attendeeEmails;
  final bool shouldNotifyAttendees;
  final DateTime date;

  CalwinEvent(this.eventid, {
    @required this.name,
    @required this.description,
    @required this.meetlink,
    @required this.attendeeEmails,
    @required this.date,
    @required this.shouldNotifyAttendees,
  });

  CalwinEvent.fromMap(Map snapshot)
      : eventid = snapshot['id'] ?? '',
        name = snapshot['name'] ?? '',
        description = snapshot['description'],
        meetlink = snapshot['meetlink'],
        attendeeEmails = snapshot['emails'] ?? '',
        shouldNotifyAttendees = snapshot['should_notify'],
        date = snapshot['date'];

  toJson() {
    return {
      'id': eventid,
      'name': name,
      'description': description,
      'emails': attendeeEmails,
      'should_notify': shouldNotifyAttendees,
      'date': date,
      'meetlink': meetlink,
    };
  }
}
