import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    return Opacity(
      opacity: 0.9,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          height: 148,
          decoration: BoxDecoration(
              color: darkTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: Stack(children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: darkTheme.colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                style: BorderStyle.solid,
                                width: 6,
                                color: DateTime.now()
                                        .toLocal()
                                        .isAfter(widget.contest.start)
                                    ? darkTheme.indicatorColor
                                    : widget.contest.calendarId != 'null'
                                        ? darkTheme.highlightColor
                                        : Colors.black))),
                    width: 0.22 * MediaQuery.of(context).size.width,
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
                  width: 0.55 * MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(8, 24, 6, 0),
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
                                    letterSpacing: 1)),
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
              ],
            ),
            Align(
                alignment: Alignment.centerRight,
                child: widget.contest.calendarId == 'null'
                    ? IconButton(
                        icon: Iconify(Mdi.calendar_plus,
                            size: 30, color: darkTheme.indicatorColor),
                        color: darkTheme.indicatorColor,
                        onPressed: () async {
                          CalendarClient client = CalendarClient();
                          try {
                            final contest = await client.insert(
                              title: widget.contest.name,
                              startTime: widget.contest.start,
                              endTime: widget.contest.end,
                            );

                            widget.contest.calendarId =
                                contest['id'].toString();

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
                          showActionSnackBar("Contest added to your calender");
                        },
                      )
                    : IconButton(
                        icon: Iconify(Mdi.calendar_remove,
                            size: 30, color: darkTheme.highlightColor),
                        color: darkTheme.highlightColor,
                        onPressed: () async {
                          try {
                            CalendarClient client = CalendarClient();
                            await client.delete(widget.contest.calendarId);
                            UserDatabase.deleteContest(
                                docId: widget.contest.docId);
                            setState(() {
                              widget.contest.calendarId = 'null';
                            });
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                          showActionSnackBar(
                              "Contest removed from your calender");
                        },
                      ))
          ]),
        ),
      ),
    );
  }
}

void showActionSnackBar(String message) {
  Fluttertoast.showToast(
      msg: message,
      timeInSecForIosWeb: 3,
      backgroundColor: darkTheme.colorScheme.secondary.withOpacity(0.90));
}
