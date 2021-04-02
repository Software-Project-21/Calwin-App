import 'dart:developer';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalwinDatabase {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static Future<void> addEvents(
      Map<String, dynamic> task, String user_id) async {
    await _db.collection('users').doc(user_id).set(task);
  }
}
/*
Web wala
const handleSubmit = () => {
        const eve = {
            id: nextId(),
            title: title,
            description: desc,
            eventDay : firebase.firestore.Timestamp.fromDate(selectedDate),
            startTime: firebase.firestore.Timestamp.fromDate(startTime),
            endTime: firebase.firestore.Timestamp.fromDate(endTime)
        }
        db.collection('users').doc(currentUser.uid).update({
            events: firebase.firestore.FieldValue.arrayUnion(eve)
        });
        props.setOpen(false);
        clear();
    }
 */
