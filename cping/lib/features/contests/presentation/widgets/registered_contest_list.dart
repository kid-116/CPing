import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cping/features/contests/data/datasources/firestore_service.dart';
import 'package:cping/features/contests/domain/entities/contests.dart';
import 'package:cping/features/contests/presentation/widgets/contest_card.dart';
import 'package:flutter/material.dart';

Expanded listRegisteredContests() {
  return Expanded(
    child: StreamBuilder(
      stream: FirestoreService.readContests(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        final collection = snapshot.data?.docs;
        List<Contest> contests = <Contest>[];

        collection?.forEach((json) {
          Contest contest =
              Contest.fromJson(json.data() as Map<String, dynamic>, json.id);
          if (contest.end.isBefore(DateTime.now()) ||
              contest.calendarId == 'null') {
            // UserDatabase.deleteContest(docId: contest.docId);
          } else {
            contests.add(contest);
          }
          print(contests.length);
          contests.sort((a, b) => a.start.compareTo(b.start));
        });

        return contests.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: contests.length,
                itemBuilder: (context, index) {
                  return ContestCard(
                    contest: contests[index],
                  );
                })
            : const Center(
                child: Image(
                  image: AssetImage('assets/images/empty.png'),
                  width: 250,
                  color: Color.fromRGBO(255, 255, 255, 0.3),
                  colorBlendMode: BlendMode.modulate,
                ),
              );
      },
    ),
  );
}
