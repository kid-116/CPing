import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../config/theme.dart';
import '../calendar/client.dart';
import '../firestore/user_data.dart';
import '../models/contest.dart';

class ContestCard extends StatefulWidget {
  final Contest contest;

  String formatDate(DateTime dateTime) {
    return DateFormat('E, d MMM y - H:mm').format(dateTime);
  }

  const ContestCard({required this.contest, Key? key}) : super(key: key);

  @override
  _ContestCardState createState() => _ContestCardState();
}

class _ContestCardState extends State<ContestCard> {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 148,
        decoration: BoxDecoration(
          color: darkTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8)
        ),
        margin: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: darkTheme.colorScheme.secondary,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              ),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            width: 6,
                            color: DateTime.now()
                                    .toLocal()
                                    .isAfter(widget.contest.start)
                                ? darkTheme.indicatorColor
                                : widget.contest.calendarId != 'null' ? darkTheme.highlightColor : Colors.black
                        ))),
                width: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.contest.start.day.toString(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 48,
                      ),
                    ),
                    Text(
                      DateFormat("MMM").format(widget.contest.start),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 190,
              padding: const EdgeInsets.fromLTRB(6, 24, 6, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text(
                  widget.contest.name,
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                        DateFormat("EEE")
                            .format(widget.contest.start)
                            .toUpperCase(),
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: darkTheme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2)),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        DateFormat("hh:mm aaa")
                                .format(widget.contest.start)
                                .toUpperCase() +
                            " - " +
                            DateFormat("hh:mm aaa")
                                .format(widget.contest.end)
                                .toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: darkTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ))
                  ],
                )
              ]),
            ),
            widget.contest.calendarId == 'null'
                ? IconButton(
                  icon: const Icon(Icons.add_task_sharp, size: 35),
                    color: darkTheme.indicatorColor,
                    onPressed: () async {
                      CalendarClient client = CalendarClient();
                      try {
                        final contest = await client.insert(
                          title: widget.contest.name,
                          startTime: widget.contest.start,
                          endTime: widget.contest.end,
                        );

                        widget.contest.calendarId = contest['id'].toString();

                        final docId = await UserDatabase.addContest(
                          calendarId: widget.contest.calendarId,
                          start: widget.contest.start.toString(),
                          name: widget.contest.name,
                          length: widget.contest.length,
                        );

                        setState(() {
                          widget.contest.docId = docId;
                        });
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                      showActionSnackBar(
                          context, "Contest added to your calender");
                    },
                    
            )
                : IconButton(
              icon: const Icon(Icons.add_task_sharp, size: 30),
              color: darkTheme.highlightColor,
                    onPressed: () async {
                      try {
                        CalendarClient client = CalendarClient();
                        await client.delete(widget.contest.calendarId);
                        UserDatabase.deleteContest(docId: widget.contest.docId);
                        setState(() {
                          widget.contest.calendarId = 'null';
                        });
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                      showActionSnackBar(
                          context, "Contest removed from your calender");
                    },
                  )
          ],
        ),
      ),
    );
  }
}

void showActionSnackBar(BuildContext context, String message) {
  Toast.show(
      message,
    duration: 3,
    // backgroundColor: Colors.grey.withAlpha(200)
    backgroundColor: darkTheme.colorScheme.secondary.withOpacity(0.90)
  );
}
