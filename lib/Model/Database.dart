import 'dart:developer';
import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';

List<String> realEmails = [];
List<dynamic> events;
var uuid = Uuid();

class CalwinDatabase {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addUser(Map<String, dynamic> task, String user_id) async {
    await _db
        .collection('users')
        .doc(user_id)
        .set(task, SetOptions(merge: true));
  }

  static Future<void> addEvents(
      Map<String, dynamic> event, String user_id) async {
    await _db.collection('users').doc(user_id).update({
      'events': FieldValue.arrayUnion([
        {
          'id': event['id'],
          'title': event['title'],
          'description': event['description'],
          'startTime': event['startTime'],
          'endTime': event['endTime'],
          'attendeeEmail': event['attendeeEmail']
        }
      ])
    });
  }

  static Future<List<dynamic>> getEvents(String user_id) async {
    await _db.collection('users').doc(user_id).get().then((value) {
      {
        //print(value.data()['events']);
        events = value.data()['events'];
        //print(events);
        return events;
      }
    });
  }

  static List<dynamic> getListEvents(String userID) {
    getEvents(userID);
    return events;
  }

  static Map<DateTime, List> getAllEvents(String userID) {
    getEvents(userID);
    Map<DateTime, List> allEvents = {};
    if (events == null) {
      return null;
    }
    for (int i = 0; i < events.length; i++) {
      var cc = events[i];
      if (cc['startTime'] == null) continue;
      DateTime eventDate = cc['startTime'].toDate();
      DateTime onlyDate =
          DateTime(eventDate.year, eventDate.month, eventDate.day);

      if (allEvents[onlyDate] == null) {
        allEvents[onlyDate] = [];
        allEvents[onlyDate].add(events[i]);
      } else {
        allEvents[onlyDate].add(events[i]);
      }
    }
    return allEvents;
  }

  static List<dynamic> getEventOnSelectedDay(String userID, DateTime curDay) {
    getEvents(userID);
    List<dynamic> curDayEvents = [];
    if (events == null)
      print('fuck');
    else {
      for (int i = 0; i < events.length; i++) {
        var cc = events[i];
        if (cc['startTime'] != null) {
          DateTime eventDate = cc['startTime'].toDate();
          if (eventDate.day == curDay.day &&
              eventDate.month == curDay.month &&
              eventDate.year == curDay.year) curDayEvents.add(events[i]);
        }
      }
      return curDayEvents;
    }
  }

  static Future<void> deleteEvent(String eventID, String userID) async {
    List<dynamic> updEvents = [];
    for (int i = 0; i < events.length; i++) {
      var cc = events[i];
      if (cc['id'] == eventID)
        continue;
      else
        updEvents.add(events[i]);
    }
    await _db.collection('users').doc(userID).update({'events': updEvents});
  }

  static Future<void> modifyEvent(
      String eventID, String userID, List<dynamic> updatedEvent) async {
    for (int i = 0; i < events.length; i++) {
      var cc = events[i];
      if (cc['id'] == eventID) {
        events[i] = updatedEvent;
        break;
      }
    }
    await _db.collection('users').doc(userID).update({'events': events});
  }

  static Future<void> checkEmail(String userEmail) async {
    bool found = false;
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .snapshots();
    snapshot.listen((event) {
      if (event.docs.isNotEmpty) {
        realEmails.add(userEmail);
      }
    });
/*
    .listen((event) async {
    print("fucked");
    var mail = await event.docs.single.data()["email"];
    print(mail);
    });

    print("  " + found.toString());
    return found;
    */
  }

  static List<String> fetchActualEmails() {
    return realEmails;
  }
}
