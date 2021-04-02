import 'package:calwin/Model/CalwinDBConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:calwin/Model/CalwinEvent.dart';

final eventDBS = DatabaseService<CalwinEvent>(
  CalwinDBConstants.usersCollection,
  fromDS: (id, data) => CalwinEvent.fromDS(id, data),
  toMap: (event) => event.toMap(),
);
