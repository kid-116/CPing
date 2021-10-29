import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_ing/models/contest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('cache');

class ContestDatabase {
  static Future<void> addContestCache({
    required String name,
    required String id,
    required String end,
    required String start,
    required String docId,
    required String endpoint,
    required String type,
  }) async {
    print("process starting");
    print(type);
    DocumentReference documentReferencer =
        _mainCollection.doc(endpoint).collection(type).doc();

    DocumentReference documentReferencer_timestamp = _mainCollection
        .doc(endpoint)
        .collection('timestamp')
        .doc("bA1j2VegSLpwyqqyqhsK");

    Map<String, String> data = <String, String>{
      "name": name,
      "id": id,
      "end": end,
      "start": start,
      "docid": docId
    };
    Map<String, Timestamp> time = <String, Timestamp>{
      "last_updated": Timestamp.now(),
    };
    print(data);
    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint('contest added to the database'))
        .catchError((e) => debugPrint(e));

    await documentReferencer_timestamp
        .set(time)
        .whenComplete(() => debugPrint("time added to the database"))
        .catchError((e) => debugPrint(e));
  }

  static Future<List<Contest>> readContests(
      {required String endpoint,
      required String type,
      required final registeredcontests}) async {
    CollectionReference contestsItemCollection =
        _mainCollection.doc(endpoint).collection(type);
    // var allcontests;
    String id = "null", docId = "null";
    List<Contest> contests = [];
    await FirebaseFirestore.instance
        .collection('cache')
        .doc(endpoint)
        .collection(type)
        .get()
        .then((collection) {
      final allcontests = collection.docs;
      allcontests.forEach((element) {
        for (var item in registeredcontests) {
          if (element['name'] == item['name']) {
            id = item['id'];
            docId = item.id;
          } else {
            id = 'null';
            docId = 'null';
          }
        }
        // debugPrint(element['start']);
        Contest c = Contest(
            name: element['name'],
            length: const Duration(),
            start: DateTime.parse(element['start']),
            end: DateTime.parse(element['end']),
            venue: "null",
            id: id,
            docId: docId);
        contests.add(c);
      });
    });
    return contests;
  }

  static Future<void> deleteContest(String endpoint, String type) async {
    _mainCollection.doc(endpoint).collection(type).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
      ;
    });
  }
}
