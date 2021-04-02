import 'dart:convert';

class CalwinEvent {
  final String title;
  final String id;
  final String description;
  final DateTime date;
  final String userId;
  // TODO: Add List of Attendees
  CalwinEvent({
    this.title,
    this.id,
    this.description,
    this.date,
    this.userId,
  });

  CalwinEvent copyWith({
    String title,
    String id,
    String description,
    DateTime date,
    String userId,
  }) {
    return CalwinEvent(
      title: title ?? this.title,
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'userId': userId,
    };
  }

  factory CalwinEvent.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CalwinEvent(
      title: map['title'],
      id: map['id'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      userId: map['userId'],
    );
  }
  factory CalwinEvent.fromDS(String id, Map<String, dynamic> data) {
    if (data == null) return null;

    return CalwinEvent(
      title: data['title'],
      id: id,
      description: data['description'],
      date: DateTime.fromMillisecondsSinceEpoch(data['date']),
      userId: data['user_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CalwinEvent.fromJson(String source) =>
      CalwinEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CalwinEvent(title: $title, id: $id, description: $description, date: $date, userId: $userId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CalwinEvent &&
        o.title == title &&
        o.id == id &&
        o.description == description &&
        o.date == date &&
        o.userId == userId;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        id.hashCode ^
        description.hashCode ^
        date.hashCode ^
        userId.hashCode;
  }
}
