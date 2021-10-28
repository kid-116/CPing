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
    required String docId,
    required String endpoint,
    required String type,
  }) async {
    print("process starting");
    DocumentReference documentReferencer =
        _mainCollection.doc(endpoint).collection(type).doc();

    DocumentReference documentReferencer_timestamp = _mainCollection
        .doc("atcoder")
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

    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint('contest added from the database'))
        .catchError((e) => debugPrint(e));

    await documentReferencer_timestamp
        .set(time)
        .whenComplete(() => debugPrint("time added to the database"))
        .catchError((e) => debugPrint(e));
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      readContests({
    required String endpoint,
    required String type,
  }) async {
    CollectionReference contestsItemCollection =
        _mainCollection.doc(endpoint).collection(type);
    var allcontests;
    await FirebaseFirestore.instance
        .collection('cache')
        .doc('atcoder')
        .collection('future-contests')
        .get()
        .then((collection) {
      final allcontests = collection.docs;
      // final registeredContests = collection.docs;
      // print(registeredContests.length);
      // registeredContests.forEach((element) {
      //   print(element.data()['start']);
      // });
    });
    return allcontests;
  }

  static Future<void> deleteContest() async {
    _mainCollection.doc("atcoder").collection('items').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
      ;
    });
  }
}
