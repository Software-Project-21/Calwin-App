import 'dart:developer';
import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';

List<dynamic> events;
List<dynamic> invitations = [];
List<dynamic> inviteInfo = [];
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
          'id': uuid.v4(),
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

  static Future<bool> checkEmail(String userEmail) async {
    QuerySnapshot res = await _db.collection("users").get();
    List<DocumentSnapshot> documents = res.docs;
    for (int i = 0; i < documents.length; i++) {
      if (documents[i].data()['email'] == userEmail) {
        print("Found in DB " + userEmail);
        return true;
      }
    }
    return false;
  }

  static Future<void> addInvite(
      String eventID, String senderName, String userID) async {
    await _db.collection('users').doc(userID).update({
      'invitations': FieldValue.arrayUnion([
        {'id': eventID, 'name': senderName}
      ])
    });
  }

  static Future<void> sendInvites(String eventID, String senderName,
      String senderEmail, List<String> emails) async {
    QuerySnapshot res = await _db.collection("users").get();
    List<DocumentSnapshot> documents = res.docs;
    for (int i = 0; i < documents.length; i++) {
      String mail = documents[i].data()['email'];
      if (emails.contains(mail) && mail != senderEmail) {
        addInvite(eventID, senderName, documents[i].id);
      }
    }
  }

  static Future<void> fetchInvites(String userID) async {
    await _db.collection('users').doc(userID).get().then((value) {
      {
        invitations = value.data()['invitations'];
      }
    });
  }

  static Future<void> getInviteInfo(String userID) async {
    await fetchInvites(userID);
    for (int i = 0; i < invitations.length; i++) {
      await _db
          .collection('events')
          .doc(invitations[i]['id'])
          .get()
          .then((value) {
        {
          inviteInfo.add(value.data());
        }
      });
    }
  }

  static List<dynamic> getListInvites(String userID) {
    getInviteInfo(userID);
    print(invitations);
    print("pyo");
    print(inviteInfo);
    return (inviteInfo == []) ? null : inviteInfo;
  }
}
