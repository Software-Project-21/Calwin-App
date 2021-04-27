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
          'id': event['id'],
          'title': event['title'],
          'description': event['description'],
          'startTime': event['startTime'],
          'endTime': event['endTime'],
          'primary': true,
        }
      ])
    });
    event['admin'] = user_id;
    event['acceptedUsers'] = [];
    event['sharedWith'] = event['attendeeEmail'];
    event.remove('attendeeEmail');
    String eventID = event['id'];
    event.remove('id');
    await _db
        .collection('events')
        .doc(eventID)
        .set(event, SetOptions(merge: true));
  }

  static Future<List<dynamic>> getEvents(String user_id) async {
    await _db.collection('users').doc(user_id).get().then((value) {
      {
        events = value.data()['events'];
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
    await _db.collection('events').doc(eventID).delete();
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

  static Future<List<dynamic>> fetchInvites(String userID) async {
    await _db.collection('users').doc(userID).get().then((value) {
      {
        invitations = value.data()['invitations'];
        return invitations;
      }
    });
  }

  static bool checkInv(Map<String, dynamic> inv) {
    if (inviteInfo.length == 0) return true;
    for (int i = 0; i < inviteInfo.length; i++) {
      var cur = inviteInfo[i];
      if (cur['id'] == inv['id']) return false;
    }
    return true;
  }

  static Future<void> getInviteInfo(String userID) async {
    fetchInvites(userID);
    for (int i = 0; i < invitations.length; i++) {
      await _db
          .collection('events')
          .doc(invitations[i]['id'])
          .get()
          .then((value) {
            {
          Map<String, dynamic> ids = value.data();
          ids['id'] = invitations[i]['id'];
          if (checkInv(ids)) {
            inviteInfo.add(ids);
          }
        }
      });
    }
    //print(invitations);
  }

  static List<dynamic> getListInvites(String userID) {
    getInviteInfo(userID);
    return inviteInfo;
  }

  static Future<void> acceptInvite(Map<String,dynamic> invite,String userID) async{
    await _db.collection('users').doc(userID).update({
      'events': FieldValue.arrayUnion([
        {
          'id': invite['id'],
          'title': invite['title'],
          'description': invite['description'],
          'startTime': invite['startTime'],
          'endTime': invite['endTime'],
          'primary': false,
        }
      ])
    });
    await _db
        .collection('events')
        .doc(invite['id'])
        .update({'acceptedUsers': FieldValue.arrayUnion([userID])});
  }


  static Future<void> deleteInvite(String userID, String eventID) async {
    List<dynamic> updInvites = [];
    for (int i = 0; i < invitations.length; i++) {
      var cc = invitations[i];
      if (cc['id'] == eventID)
        continue;
      else {
        updInvites.add(invitations[i]);
      }
    }
    await _db.collection('users').doc(userID).update({'invitations': updInvites});
    inviteInfo.clear();
    getInviteInfo(userID);
  }
}
