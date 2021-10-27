import 'package:cloud_firestore/cloud_firestore.dart';
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
  }) async {
    print("process starting");
    DocumentReference documentReferencer =
        _mainCollection.doc("atcoder").collection('items').doc();

    DocumentReference documentReferencer_timestamp = _mainCollection
        .doc("atcoder")
        .collection('timestamp')
        .doc("bA1j2VegSLpwyqqyqhsK");

    Map<String, String> data = <String, String>{
      "name": name,
      "id": id,
      "end": end,
      "start": start,
    };
    Map<String, Timestamp> time = <String, Timestamp>{
      "last_updated": Timestamp.now(),
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint('contest deleted from the database'))
        .catchError((e) => debugPrint(e));

    await documentReferencer_timestamp
        .set(time)
        .whenComplete(() => debugPrint("time added to the database"))
        .catchError((e) => debugPrint(e));
  }

  static Stream<QuerySnapshot> readContests() {
    CollectionReference contestsItemCollection =
        _mainCollection.doc("atcoder").collection('items');

    return contestsItemCollection.snapshots();
  }

  static Future<void> deleteContest() async {
    _mainCollection.doc("atcoder").collection('items').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
