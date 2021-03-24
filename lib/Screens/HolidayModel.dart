class HolidayModel {
  final String name;
  final DateTime hdate;

  HolidayModel({this.name, this.hdate});

  factory HolidayModel.fromJson(final json) {
    return HolidayModel(
        name: json['response']['holidays'],
        hdate: json.response.holidays[2].date.iso);
  }
}
