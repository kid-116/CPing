import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_ing/firestore/cache.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cp_ing/models/contest.dart';

class WebsiteRepository {
  late String endpoint;

  WebsiteRepository({
    required this.endpoint,
  });

  Future<List<Contest>> getContestsFromCache(String type) async {
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
          type: type,
        ).then((contests) {
          for (final contest in contests) {
            for(final registeredContest in registeredContests) {
              if (registeredContest['name'] == contest.name) {
                contest.calendarId = registeredContest['name'];
                contest.docId = registeredContest.id;
              }
            }
          }
          return contests;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    return <Contest>[];
  }

  void setEndpoint(String endpoint) {
    this.endpoint = endpoint;
  }
}
