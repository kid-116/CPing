import 'package:cp_ing/calendar/client.dart';
import 'package:cp_ing/config/colors.dart';
import 'package:cp_ing/models/contest.dart';
import 'package:cp_ing/models/contest_hive.dart';
import 'package:cp_ing/widgets/time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ContestCard extends StatefulWidget {
  final Contest contest;

  String formatDate(DateTime dateTime) {
    return DateFormat('E, d MMM y - H:mm').format(dateTime);
  }

  String formatLength(Duration length) {
    int strLen = length.toString().length;
    return length.toString().substring(0, strLen - 10);
  }

  const ContestCard({required this.contest, Key? key}) : super(key: key);

  @override
  _ContestCardState createState() => _ContestCardState();
}

class _ContestCardState extends State<ContestCard> {
  late Box contestBox;

  static const TextStyle contestNameStyle = TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontFamily: 'Kaisei',
    letterSpacing: 0.8,
  );

  @override
  void initState() {
    contestBox = Hive.box(FirebaseAuth.instance.currentUser!.email!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 30,
      ),
      child: Container(
        color: MyColors.navyBlue,
        // width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              widget.contest.name,
              style: contestNameStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            color: Colors.brown,
          ),
          const SizedBox(height: 10),
          // Text(widget.formatLength(widget.contest.length)),
          // Text(widget.formatDate(widget.contest.start)),
          // Text(widget.formatDate(widget.contest.end)),
          Row(
            children: [
              Time(time: widget.contest.start),
              // const VerticalDivider(
              //   color: Colors.white,
              //   thickness: 2,
              //   width: 20,
              // ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
              ),
              Time(time: widget.contest.end),
            ],
          ),
          // Text(widget.contest.id),
          widget.contest.id == 'null'
              ? TextButton(
                  onPressed: () async {
                    CalendarClient client = CalendarClient();
                    try {
                      var event = await client.insert(
                        title: widget.contest.name,
                        startTime: widget.contest.start,
                        endTime: widget.contest.end,
                      );
                      setState(() {
                        widget.contest.id = event['id'].toString();
                      });
                      contestBox.put(
                          widget.contest.id,
                          ContestHive(
                            id: widget.contest.id,
                            start: widget.contest.start.toString(),
                            end: widget.contest.end.toString(),
                            name: widget.contest.name,
                            venue: widget.contest.venue,
                          ));
                    } catch (e) {
                      print('event coould not be added');
                      print(e);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ))
              : TextButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      CalendarClient client = CalendarClient();
                      await client.delete(widget.contest.id);
                      print('deleting contest');
                      contestBox.delete(widget.contest.id);
                      setState(() {
                        widget.contest.id = 'null';
                      });
                    } catch (e) {
                      print('event could not be deleted');
                      print(e);
                    }
                  },
                )
        ]),
      ),
    );
  }
}
