import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_ing/firestore/cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cp_ing/models/contest.dart';
import 'package:http/http.dart' as http;

class WebsiteRepository {
  late String endpoint;
  static const String hostUrl = "https://kid116shash-cping.herokuapp.com/";

  WebsiteRepository({
    required this.endpoint,
  });

  Future<int> updateCache() async {
    try {
      debugPrint("updating cache");
      await http.get(Uri.parse(hostUrl + endpoint));
    } catch(e) {
      debugPrint(e.toString());
      return -1;
    }
    debugPrint("cache has been updated");
    return 0;
  }

  Future<List<Contest>> getContestsFromCache() async {
    List<Contest> contests = <Contest>[];
    try {
      String site = endpoint.split('/')[1];
      final email = FirebaseAuth.instance.currentUser!.email;
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(email)
          .collection('registeredContests')
          .get()
          .then((collection) async {
        final registeredContests = collection.docs;
        await CacheDatabase.getContests(
          site: site,
        ).then((res) {
          contests = res;

          for (final contest in contests) {
            for(final registeredContest in registeredContests) {
              if (registeredContest['name'] == contest.name) {
                contest.calendarId = registeredContest['calendarId'];
                contest.docId = registeredContest.id;
              }
            }
          }
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    contests.sort((a, b) => a.start.compareTo(b.start));
    return contests;
  }

  void setEndpoint(String endpoint) {
    this.endpoint = endpoint;
  }
}
