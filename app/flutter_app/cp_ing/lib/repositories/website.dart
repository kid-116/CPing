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
      debugPrint("1");
      var response = await http.get(Uri.parse(hostUrl + endpoint));
      debugPrint("2");

      final email = FirebaseAuth.instance.currentUser!.email;
      await FirebaseFirestore.instance
      .collection('contests')
      .doc(email)
      .collection('items')
      .get()
      .then((collection) {
        final registeredContests = collection.docs;
        debugPrint("3");
        var data = json.decode(response.body);
        debugPrint("res: $data.toString()");
        for (var item in data[type]) {
          Contest contest = Contest.fromJson(item, registeredContests);
          contests.add(contest);
        }
      });
    } catch(e) {
      debugPrint(e.toString());
    }
    debugPrint("returned: $contests.toString()");
    return contests;
  }

  void setEndpoint(String endpoint) {
    this.endpoint = endpoint;
  }
}
