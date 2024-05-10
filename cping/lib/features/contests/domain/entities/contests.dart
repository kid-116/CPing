import 'package:equatable/equatable.dart';

class Contest extends Equatable {
  late String id;
  late Duration length;
  late String name;
  late DateTime start;
  late DateTime end;
  late String calendarId = 'null';
  late String docId = 'null';
  Contest({
    required this.id,
    required this.name,
    required this.length,
    required this.start,
    required this.end,
    required this.calendarId,
    required this.docId,
  });

  Contest.fromJson(Map<String, dynamic> json, String id) {
    id = id;
    length = Duration(seconds: json['length']);
    name = json['name'];
    start = json['start'].toDate().toLocal();
    end = start.add(length);
    json['calendarId'] != null
        ? calendarId = json['calendarId']
        : calendarId = 'null';
    json['docId'] != null ? docId = json['docId'] : docId = 'null';
  }

  @override
  List<Object?> get props => [name, length, start, end, calendarId, docId];
}
