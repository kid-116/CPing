import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

import '../models/contest.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference cacheCollection = firestore.collection('cache');

class CacheDatabase {
  static Future<Timestamp> getLastUpdated({
    required String site,
  }) async {
    Timestamp lastUpdated = await cacheCollection
        .doc(site)
        .collection("timestamp")
        .get()
        .then((value) => value.docs[0].data()['at']);
    return lastUpdated;
  }

  static Future<List<Contest>> getContests({
    required String site,
  }) async {
    List<Contest> contests = <Contest>[];
    await FirebaseFirestore.instance
        .collection('cache')
        .doc(site)
        .collection('contests')
        .get()
        .then((collection) {
      for (final json in collection.docs) {
        final length = Duration(
            days: json['length']['days'],
            hours: json['length']['hours'],
            minutes: json['length']['minutes']);
        final start = DateTime.parse(json['start']).toLocal();
        Contest contest = Contest(
            name: json['name'],
            length: length,
            start: start,
            end: start.add(length),
            calendarId: 'null',
            docId: 'null');

        if (contest.end.isAfter(DateTime.now())) {
          contests.add(contest);
        }
      }
    });
    return contests;
  }
}
