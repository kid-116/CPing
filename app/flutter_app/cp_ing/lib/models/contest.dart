import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_ing/firestore/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Contest {
  late Duration length;
  late String name;
  late DateTime start;
  late DateTime end;
  late String venue;
  late String id = 'null';
  late String docId = 'null';

  Contest({
    required this.name,
    required this.length,
    required this.start,
    required this.end,
    required this.venue,
    required this.id,
    required this.docId,
  });

  Contest.fromJson(Map<String, dynamic> json, dynamic registeredContests) {
    length = Duration(
        days: json['length']['days'],
        hours: json['length']['hours'],
        minutes: json['length']['minutes']);
    name = json['name'];
    start = DateTime.parse(json['start']).toLocal();
    end = start.add(length);
    venue = json['venue'];

    for (final contest in registeredContests) {
      if (contest['name'] == name) {
        id = contest['id'];
        docId = contest.id;
      }
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = length;
    data['name'] = name;
    data['start'] = start;
    data['id'] = id;
    data['end'] = end;
    data['venue'] = venue;
    return data;
  }
}
