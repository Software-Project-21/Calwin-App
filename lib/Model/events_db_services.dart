import 'package:calwin/Model/CalwinDBConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:calwin/Model/CalwinUser.dart';

final eventDBS = DatabaseService<CalwinUser>(
  CalwinDBConstants.usersCollection,
  fromDS: (id, data) => CalwinUser.fromDS(id, data),
  toMap: (event) => event.toMap(),
);
