import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cping/features/contests/domain/entities/contests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference userCollection = firestore.collection('userData');

class FirestoreService {
  static Future<List<Contest>> getContests({
    required String site,
  }) async {
    List<Contest> contests = <Contest>[];
    final registeredContests = [];
    await getRegisteredContests();
    // print(registeredContests);
    await FirebaseFirestore.instance
        .collection('cache')
        .doc(site)
        .collection('contests')
        .get()
        .then((collection) {
      print("Hello my name is shashank");
      contests = jsonToContestList(collection, site);
      print(contests.length);
      for (final contest in contests) {
        print(contest);
        print(contest.site + "=========");
        for (final registeredContest in registeredContests) {
          if (registeredContest.name == contest.name) {
            contest.calendarId = registeredContest.calendarId;
            contest.docId = registeredContest.docId;
          }
        }
      }
    });
    contests.sort((a, b) => a.start.compareTo(b.start));
    return contests;
  }

  static Future<List<Contest>> getRegisteredContests() async {
    final email = FirebaseAuth.instance.currentUser!.email;
    List<Contest> contests = <Contest>[];
    // Todo Make changes

    await FirebaseFirestore.instance
        .collection('userData')
        .doc(email) // change this to email
        .collection('registeredContests')
        .get()
        .then((collection) async {
      final registeredContests = jsonToContestList(collection, null);
      for (final contest in registeredContests) {
        if (contest.end.isAfter(DateTime.now())) {
          contests.add(contest);
        }
      }
    });
    contests.sort((a, b) => a.start.compareTo(b.start));
    return contests;
  }

  static Future<Contest> getSingleContest(String site, String contestId) async {
    late Contest contest;
    await FirebaseFirestore.instance
        .collection('cache')
        .doc(site)
        .collection('contests')
        .doc(contestId)
        .get()
        .then((res) {
      contest = Contest.fromJson(res.data()!, contestId, site);
    });
    return contest;
  }

  static List<Contest> jsonToContestList(
      QuerySnapshot<Map<String, dynamic>> json, String? site) {
    List<Contest> contests = <Contest>[];
    for (final json in json.docs) {
      Contest contest = Contest.fromJson(json.data(), json.id, site);
      print(contest);
      print(contest.site);
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
    required String calendarId,
    required String site,
    required String contestId,
    required String name,
    required DateTime startTime,
    required int length,
  }) async {
    final email = FirebaseAuth.instance.currentUser!.email;
    DocumentReference newContestDoc = userCollection
        .doc(email)
        .collection('registeredContests')
        .doc(contestId);

    Map<String, dynamic> data = <String, dynamic>{
      "calendarId": calendarId,
      "site": site,
      "name": name,
      "start": startTime,
      "length": length,
    };

    await newContestDoc.set(data).catchError((e) => print(e));

    return newContestDoc.id;
  }

  static Future<void> deleteContest({
    required String docId,
  }) async {
    final email = FirebaseAuth.instance.currentUser!.email;
    DocumentReference registeredContest =
        userCollection.doc(email).collection('registeredContests').doc(docId);

    await registeredContest.delete().catchError((e) => debugPrint(e));
  }
}
