import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

// ignore: non_constant_identifier_names
Map<DateTime, List> holidays_list;

class SubHoliday {
  String name;
  String desc;
  String dt;
  SubHoliday(this.name, this.desc, this.dt);

  factory SubHoliday.fromJson(dynamic json) {
    return SubHoliday(json['name'] as String, json['description'] as String,
        json['date']['iso'] as String);
  }
  @override
  String toString() {
    return '{ ${this.name}, ${this.desc}, ${this.dt} }';
  }
}

class HolidayModel {
  SubHoliday nameDecsDate;

  HolidayModel.fromJson(final json) {
    var tagObjsJson = json['response']['holidays'] as List;
    List<SubHoliday> subHolidays =
        tagObjsJson.map((tagJson) => SubHoliday.fromJson(tagJson)).toList();
    holidays_list = {};
    for (int i = 0; i < subHolidays.length; i++) {
      nameDecsDate = subHolidays[i];
      DateTime formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(nameDecsDate.dt.toString())));
      if (holidays_list.containsKey(formattedDate)) {
        // continue;
        holidays_list[formattedDate].add(nameDecsDate.name.toString());
      } else {
        holidays_list[formattedDate] = [nameDecsDate.name.toString()];
      }
    }
    //print(subHolidays);
  }
}
