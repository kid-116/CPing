import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cping/features/contests/domain/entities/contests.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference userCollection = firestore.collection('userData');

class FirestoreService {
  static Future<List<Contest>> getContests({
    required String site,
  }) async {
    List<Contest> contests = <Contest>[];
    final registeredContests = await getRegisteredContests();

    await FirebaseFirestore.instance
        .collection('cache')
        .doc(site)
        .collection('contests')
        .get()
        .then((collection) {
      contests = jsonToContestList(collection);
      print(contests.length);
      print(registeredContests.length);
      print("Starting to loop");
      print(contests);
      for (final contest in contests) {
        print("outer loop \n");
        for (final registeredContest in registeredContests) {
          print("inner loop \n");
          if (registeredContest.name == contest.name) {
            contest.calendarId = registeredContest.calendarId;
            contest.docId = registeredContest.docId;
          }
        }
      }
    });
    contests.sort((a, b) => a.start.compareTo(b.start));
    print(contests);
    return contests;
  }

  static Future<List<Contest>> getRegisteredContests() async {
    final email = FirebaseAuth.instance.currentUser!.email;
    List<Contest> contests = <Contest>[];
    await FirebaseFirestore.instance
        .collection('userData')
        .doc(email) // change this to email
        .collection('registeredContests')
        .get()
        .then((collection) async {
      final registeredContests = jsonToContestList(collection);
      for (final contest in registeredContests) {
        if (contest.end.isAfter(DateTime.now())) {
          contests.add(contest);
        }
      }
    });
    contests.sort((a, b) => a.start.compareTo(b.start));
    return contests;
  }

  static List<Contest> jsonToContestList(
      QuerySnapshot<Map<String, dynamic>> json) {
    List<Contest> contests = <Contest>[];
    for (final json in json.docs) {
      Contest contest = Contest.fromJson(json.data(), json.id);
      contests.add(contest);
    }
    return contests;
  }

  static Stream<QuerySnapshot> readContests() {
    final email = FirebaseAuth.instance.currentUser!.email;
    CollectionReference registeredContests = userCollection
        .doc(email)
        .collection('registeredContests'); // to change to email
    return registeredContests.snapshots();
  }

  static Future<String> addContest({
    required String name,
    required String calendarId,
    required DateTime start,
    required int length,
  }) async {
    final email = FirebaseAuth.instance.currentUser!.email;
    DocumentReference newContestDoc =
        userCollection.doc(email).collection('registeredContests').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "calendarId": calendarId,
      "start": start,
      "length": length
    };

    await newContestDoc.set(data).catchError((e) => print(e));

    return newContestDoc.id;
  }
}
