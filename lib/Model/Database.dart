import 'dart:developer';
import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<dynamic> eves;

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
          'title': event['title'],
          'description': event['description'],
          'startTime': event['startTime'],
          'endTime': event['endTime'],
          'attendeeEmail': event['attendeeEmail']
        }
      ])
    });
  }

  static Future<Map<DateTime, List<dynamic>>> getEvents(
      String user_id, DateTime date) async {
    await _db.collection('users').doc(user_id).get().then((value) {
      return value.data()['events'];
    });
    /*
    await _db.collection('users').doc(user_id).get().then((value) {
      print(value.data());
    });
     */
  }
}
