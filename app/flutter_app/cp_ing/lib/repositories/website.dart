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

  Future addConteststoCache(String type) async {
    List<Contest> contests = [];
    try {
      String a = endpoint.split('/')[1];
      // This function would call the API and the API would update the data
      await http.get(Uri.parse(hostUrl + endpoint));

      // ! DO NOT DELETE
      // ! DO NOT DELETE
      // ! DO NOT DELETE

      // Code to add contests to cache
      // await FirebaseFirestore.instance
      //     .collection('contests')
      //     .doc(email)
      //     .collection('items')
      //     .get()
      //     .then((collection) async {
      //   final registeredContests = collection.docs;
      //   debugPrint("3");
      //   var data = json.decode(response.body);
      //   debugPrint("res: $data.toString()");
      //   for (var item in data[type]) {
      //     Contest contest = Contest.fromJson(item, registeredContests);

      // await ContestDatabase.addContestCache(
      //   end: contest.end.toString(),
      //   docId: 'null',
      //   endpoint: a,
      //   id: 'null',
      //   name: contest.name,
      //   start: contest.start.toString(),
      //   type: type,
      // );
      //     contests.add(contest);
      //   }
      // });

      // ! DO NOT DELETE
      // ! DO NOT DELETE
      // ! DO NOT DELETE

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
      final email = FirebaseAuth.instance.currentUser!.email;
      await FirebaseFirestore.instance
          .collection('contests')
          .doc(email)
          .collection('items')
          .get()
          .then((collection) async {
        // Registered contests called to assingn id and docId to contests called from the cache
        final registeredContests = collection.docs;
        // This function would get contests from cache
        await ContestDatabase.readContests(
                endpoint: a, type: type, registeredcontests: registeredContests)
            .then((value) {
          contests = value;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return contests;
  }

  void setEndpoint(String endpoint) {
    this.endpoint = endpoint;
  }
}
