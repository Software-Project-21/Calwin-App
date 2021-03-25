import 'dart:convert';

import '../Model/HolidayModel.dart';
import 'package:http/http.dart' as http;

Future<HolidayModel> getHolidayDetails() async {
  final url =
      "https://calendarific.com/api/v2/holidays?&api_key=7a89396e323170ff1fd03746026fc65afcd51cae&country=in&year=2021";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonStudent = jsonDecode(response.body);
    return HolidayModel.fromJson(jsonStudent);
  } else {
    throw Exception();
  }
}

/*
final Map<DateTime, List> holidays_list = {
  DateTime(2021, 1, 1): ['New Year\'s Day'],
  DateTime(2021, 3, 28): ['Holi'],
  DateTime(2021, 4, 2): ['Good Friday'],
  DateTime(2021, 4, 14): ['Ambedkar Jyanti'],
  DateTime(2021, 4, 21): ['Ram Navami'],
  DateTime(2021, 5, 1): ['Labour Day'],
  DateTime(2021, 5, 14): ['Eid al-Fitr'],
};
*/
