import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_ing/models/contest.dart';

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
    required String type,
  }) async {
    List<Contest> contests = [];
    await FirebaseFirestore.instance
        .collection('cache')
        .doc(site)
        .collection(type)
        .get()
        .then((collection) {
      for (final json in collection.docs) {
        final length = Duration(
            days: json['length']['days'],
            hours: json['length']['hours'],
            minutes: json['length']['minutes']);
        final start = DateTime.parse(json['start']);
        Contest contest = Contest(
            name: json['name'],
            length: length,
            start: start,
            end: start.add(length),
            calendarId: 'null',
            docId: 'null');
        contests.add(contest);
      }
    });
    return contests;
  }
}
