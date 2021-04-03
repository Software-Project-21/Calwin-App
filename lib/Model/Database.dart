import 'dart:developer';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

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
