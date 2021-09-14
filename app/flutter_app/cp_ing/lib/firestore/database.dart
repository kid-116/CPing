import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('contests');

class Database {
  static Future<void> addContest({
    required String name,
    required String id,
    required String end,
    required String start,
  }) async {
    final email = FirebaseAuth.instance.currentUser!.email;

    DocumentReference documentReferencer =
      _mainCollection.doc(email).collection('items').doc();

    Map<String, String> data = <String, String>{
      "name": name,
      "id": id,
      "end": end,
      "start": start,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("contest added to the database"))
        .catchError((e) => debugPrint(e));
  }

  static Stream<QuerySnapshot> readContests() {
    final email = FirebaseAuth.instance.currentUser!.email;

    CollectionReference contestsItemCollection =
      _mainCollection.doc(email).collection('items');

    return contestsItemCollection.snapshots();
  }

  static Future<void> deleteContest({
    required String docId,
  }) async {
    final email = FirebaseAuth.instance.currentUser!.email;

    DocumentReference documentReferencer =
      _mainCollection.doc(email).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => debugPrint('contest deleted from the database'))
        .catchError((e) => debugPrint(e));
  }
}