import 'package:cping/config/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:googleapis/appengine/v1.dart';

class Contest extends Equatable {
  late String id;
  late Duration length;
  late String name;
  late DateTime start;
  late DateTime end;
  late String site;
  late String url;
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
    required this.site,
    required this.url,
  });

  Contest.fromJson(Map<String, dynamic> json, this.id, String? site) {
    print("This is the json");
    print(json['length']);
    print(json);
    length = Duration(seconds: json['length']);
    name = json['name'];
    start = json['start'].toDate().toLocal();
    end = start.add(length);
    json['calendarId'] != null
        ? calendarId = json['calendarId']
        : calendarId = 'null';
    docId = id;

    url = urlMapping[site ?? json["site"]]! + id;
    this.site = site ?? json["site"];
  }

  @override
  List<Object?> get props =>
      [name, length, start, end, calendarId, docId, site, url];
}
