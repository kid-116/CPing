import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:cp_ing/models/contest.dart';

class WebsiteRepository {
  static const String hostUrl = "https://kid116shash-cping.herokuapp.com/";
  late String endpoint;

  WebsiteRepository({
    required this.endpoint,
  });

  Future<List<Contest>> getWebsiteContests(String type) async {
    List<Contest> contests = [];
    try {
      // print("fetching contests...");
      var response = await http.get(Uri.parse(hostUrl + endpoint));
      // print("response served...");
      final email = FirebaseAuth.instance.currentUser!.email;

      FirebaseFirestore.instance
      .collection('contests')
      .doc(email)
      .collection('items')
      .get()
      .then((collection) {
        // debugPrint(collection.toString());
        final registeredContests = collection.docs;

        var data = json.decode(response.body);
        for (var item in data[type]) {
          Contest contest = Contest.fromJson(item, registeredContests);
          contests.add(contest);
        }
      });


    } catch(e) {
      debugPrint(e.toString());
    }
    return contests;
  }

  void setEndpoint(String endpoint) {
    this.endpoint = endpoint;
  }
}
