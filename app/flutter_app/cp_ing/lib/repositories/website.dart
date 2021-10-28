import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_ing/firestore/cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/compute/v1.dart';
import 'package:http/http.dart' as http;
import 'package:cp_ing/models/contest.dart';

class WebsiteRepository {
  static const String hostUrl = "https://kid116shash-cping.herokuapp.com/";
  late String endpoint;

  WebsiteRepository({
    required this.endpoint,
  });
  Future<void> addtocache(Contest contest) async {
    // await ContestDatabase.addContestCache(
    //                   end: contest.end, id: contest.id, name: 'das', start: 'das');
  }
  Future addConteststoCache(String type) async {
    List<Contest> contests = [];
    try {
      String a = endpoint.split('/')[1];

      var response = await http.get(Uri.parse(hostUrl + endpoint));

      final email = FirebaseAuth.instance.currentUser!.email;

      await FirebaseFirestore.instance
          .collection('contests')
          .doc(email)
          .collection('items')
          .get()
          .then((collection) async {
        final registeredContests = collection.docs;

        debugPrint("3");

        var data = json.decode(response.body);

        debugPrint("res: $data.toString()");

        for (var item in data[type]) {
          Contest contest = Contest.fromJson(item, registeredContests);

          await ContestDatabase.addContestCache(
            end: contest.end.toString(),
            docId: 'null',
            endpoint: a,
            id: 'null',
            name: contest.name,
            start: contest.start.toString(),
            type: type,
          );
          contests.add(contest);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint("returned: $contests.toString()");
    // return contests;
  }

  Future<List<Contest>> getWebsiteContestsfromCache(String type) async {
    List<Contest> contests = [];
    try {
      String a = endpoint.split('/')[1];
      dynamic c;
      print(type);
      final registeredContests;
      final email = FirebaseAuth.instance.currentUser!.email;
      await FirebaseFirestore.instance
          .collection('contests')
          .doc(email)
          .collection('items')
          .get()
          .then((collection) async {
        final registeredContests = collection.docs;
        await ContestDatabase.readContests(
                endpoint: a, type: type, registeredcontests: registeredContests)
            .then((value) {
          contests = value;
        });
        print(contests.length);
      });
      // final email = FirebaseAuth.instance.currentUser!.email;
      // late String id, docId;
      // await FirebaseFirestore.instance
      //     .collection('contests')
      //     .doc(email)
      //     .collection('items')
      //     .get()
      //     .then((collection) async {
      //   registeredContests = collection.docs;
      // });
      // contestsnapshot.then((value) {
      //   print(value.length);
      //   for (var item in value) {
      //     for (final contest in registeredContests) {
      //       if (contest['name'] == item.data()['name']) {
      //         id = contest['id'];
      //         docId = contest.id;
      //       }
      //     }

      //     Contest a = Contest(
      //         name: item.data()['name'],
      //         start: item.data()['start'],
      //         end: item.data()['end'],
      //         id: id,
      //         docId: docId,
      //         venue: "null",
      //         length: c);
      //     contests.add(a);
      //   }
      // }

      // );
    } catch (e) {
      debugPrint(e.toString());
    }
    return contests;
  }

  void setEndpoint(String endpoint) {
    this.endpoint = endpoint;
  }
}
