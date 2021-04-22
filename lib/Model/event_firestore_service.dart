import 'package:calwin/Model/CalwinDBConstants.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

import 'App_Event.dart';

final eventDBS = DatabaseService<AppEvent>(
  CalwinDBConstants.usersCollection,
  fromDS: (id, data) => AppEvent.fromDS(id, data),
  toMap: (event) => event.toMap(),
);