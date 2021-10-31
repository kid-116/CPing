import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference userCollection = firestore.collection('userData');

class UserDatabase {
  static Future<void> addContest({
    required String name,
    required String calendarId,
    required String start,
    required Duration length,
  }) async {
    final email = FirebaseAuth.instance.currentUser!.email;
    DocumentReference newContestDoc =
      userCollection.doc(email).collection('registeredContests').doc();

    debugPrint(length.toString());

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "calendarId": calendarId,
      "start": start,
    };

    // await newContestDoc
    //     .set(data)
    //     .whenComplete(() => debugPrint("$name added to $email's contests"))
    //     .catchError((e) => debugPrint(e));
  }

  static Stream<QuerySnapshot> readContests() {
    final email = FirebaseAuth.instance.currentUser!.email;
    CollectionReference registeredContests =
      userCollection.doc(email).collection('registeredContests');
    return registeredContests.snapshots();
  }

  static Future<void> deleteContest({
    required String docId,
  }) async {
    final email = FirebaseAuth.instance.currentUser!.email;
    DocumentReference registeredContest =
      userCollection.doc(email).collection('registeredContests').doc(docId);

    await registeredContest
        .delete()
        .whenComplete(() => debugPrint("$docId removed from $email's contests"))
        .catchError((e) => debugPrint(e));
  }
}