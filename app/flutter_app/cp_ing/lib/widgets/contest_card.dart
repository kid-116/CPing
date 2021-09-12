import 'package:cp_ing/blocs/authentication/bloc.dart';
import 'package:cp_ing/calendar/client.dart';
import 'package:cp_ing/models/contest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:googleapis/calendar/v3.dart' as cal;

class ContestCard extends StatefulWidget {
  final Contest contest;

  String formatDate(DateTime dateTime) {
    return DateFormat('E, d MMM y - H:mm').format(dateTime);
  }

  String formatLength(Duration length) {
    int strLen = length.toString().length;
    return length.toString().substring(0, strLen - 10);
  }

  const ContestCard({
    required this.contest,
    Key? key
  }) : super(key: key);

  @override
  _ContestCardState createState() => _ContestCardState();
}

class _ContestCardState extends State<ContestCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(children: <Widget>[
        Text(widget.contest.name),
        Text(widget.formatLength(widget.contest.length)),
        Text(widget.formatDate(widget.contest.start)),
        Text(widget.formatDate(widget.contest.end)),
        Text(widget.contest.id),
        TextButton(
            onPressed: () async {
              var authHeaderBox = Hive.box('authHeader');
              final authHeaders = authHeaderBox.get('authHeader').header;
              final client = GoogleAuthClient(authHeaders);
              CalendarClient.calendar = cal.CalendarApi(client);
              var event = await CalendarClient().insert(
                title: widget.contest.name,
                startTime: widget.contest.start,
                endTime: widget.contest.end,
              );
              setState(() {
                widget.contest.id = event['id'].toString();
              });
            },
            child: const Text('Set reminder'))
      ]),
    );;
  }
}
