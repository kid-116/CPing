import 'package:cping/config/theme.dart';
import 'package:cping/features/contests/data/datasources/contest_remote_datasource.dart';
import 'package:cping/features/contests/data/repositories/contest_repository_impl.dart';
import 'package:cping/features/contests/domain/usecases/add_calendar_event.dart';
import 'package:cping/features/contests/domain/usecases/delete_calendar_event.dart'
    as dce;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cping/features/contests/domain/entities/contests.dart';

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
    ValueNotifier<String> isRegistered =
        ValueNotifier(widget.contest.calendarId != "null" ? "true" : "false");
    return Container(
      // height: 198,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),

      // padding: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
          color: darkTheme.colorScheme.tertiary,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Opacity(
            opacity: 0.9,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 148,
                decoration: BoxDecoration(
                  color: darkTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
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
                                widget.contest.name.length > 40
                                    ? widget.contest.name.substring(0, 40) +
                                        '...'
                                    : widget.contest.name,
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
                                          color:
                                              darkTheme.colorScheme.secondary,
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
                ]),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ValueListenableBuilder(
                  valueListenable: isRegistered,
                  builder: ((context, value, child) {
                    if (value == "false") {
                      return IconButton(
                        icon: Iconify(Mdi.calendar_plus,
                            size: 30, color: darkTheme.indicatorColor),
                        color: darkTheme.indicatorColor,
                        onPressed: () async {
                          AddToCalendar addToCalendar = AddToCalendar(
                              ContestsRepositoryImpl(
                                  remoteDataSource:
                                      ContestsRemoteDataSourceImpl()));
                          final result = await addToCalendar.call(Params(
                              title: widget.contest.name,
                              startTime: widget.contest.start,
                              length: widget.contest.length.inSeconds,
                              isRegistered: isRegistered,
                              site: widget.contest.site,
                              contestId: widget.contest.id));
                          result.fold(
                            (l) {
                              showActionSnackBar(
                                  "Error adding contest to calender");
                            },
                            (r) {
                              widget.contest.calendarId = r['contestId']!;
                              widget.contest.docId = r['docId']!;
                              showActionSnackBar(
                                  "Contest added to your calender");
                            },
                          );
                        },
                      );
                    } else if (value == "true") {
                      return IconButton(
                        icon: Iconify(Mdi.calendar_remove,
                            size: 30, color: darkTheme.highlightColor),
                        color: darkTheme.highlightColor,
                        onPressed: () async {
                          try {
                            dce.DeleteFromCalendar deleteFromCalendar =
                                dce.DeleteFromCalendar(ContestsRepositoryImpl(
                                    remoteDataSource:
                                        ContestsRemoteDataSourceImpl()));
                            final result = await deleteFromCalendar.call(
                                dce.Params(
                                    calendarId: widget.contest.calendarId,
                                    contestId: widget.contest.docId,
                                    isRegistered: isRegistered));
                            result.fold((l) {
                              showActionSnackBar(
                                  "Error deleting contest from your calender");
                            }, (r) {
                              showActionSnackBar(
                                  "Contest deleted from your calender");
                            });
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                          showActionSnackBar(
                              "Contest removed from your calender");
                        },
                      );
                    } else if (value == "loading") {
                      return CircularProgressIndicator(
                        color: Colors.white,
                      );
                    } else {
                      return Container();
                    }
                  })),
              // widget.contest.calendarId == 'null'
              //     ? IconButton(
              //         icon: Iconify(Mdi.calendar_plus,
              //             size: 30, color: darkTheme.indicatorColor),
              //         color: darkTheme.indicatorColor,
              //         onPressed: () async {
              //           print("Adding to calendar");
              //           AddToCalendar getContests = AddToCalendar(
              //               ContestsRepositoryImpl(
              //                   remoteDataSource:
              //                       ContestsRemoteDataSourceImpl()));
              //           final contests = await getContests.call(Params(
              //               title: widget.contest.name,
              //               startTime: widget.contest.start,
              //               endTime: widget.contest.end));
              //           // CalendarClient client = CalendarClient();
              //           // try {
              //           //   final contest = await client.insert(
              //           //     title: widget.contest.name,
              //           //     startTime: widget.contest.start,
              //           //     endTime: widget.contest.end,
              //           //   );

              //           //   widget.contest.calendarId =
              //           //       contest['id'].toString();

              //           //   final docId = await UserDatabase.addContest(
              //           //     calendarId: widget.contest.calendarId,
              //           //     start: widget.contest.start.toString(),
              //           //     name: widget.contest.name,
              //           //     length: widget.contest.length,
              //           //   );

              //           //   setState(() {
              //           //     widget.contest.docId = docId;
              //           //   });
              //           // } catch (e) {
              //           //   debugPrint(e.toString());
              //           // }
              //           // showActionSnackBar("Contest added to your calender");
              //         },
              //       )
              //     : IconButton(
              //         icon: Iconify(Mdi.calendar_remove,
              //             size: 30, color: darkTheme.highlightColor),
              //         color: darkTheme.highlightColor,
              //         onPressed: () async {
              //           // try {
              //           //   CalendarClient client = CalendarClient();
              //           //   await client.delete(widget.contest.calendarId);
              //           //   UserDatabase.deleteContest(
              //           //       docId: widget.contest.docId);
              //           //   setState(() {
              //           //     widget.contest.calendarId = 'null';
              //           //   });
              //           // } catch (e) {
              //           //   debugPrint(e.toString());
              //           // }
              //           // showActionSnackBar(
              //           //     "Contest removed from your calender");
              //         },
              //       ),
              IconButton(
                icon: Iconify(Mdi.open_in_new, size: 30, color: Colors.white),
                onPressed: () {
                  // launch(widget.contest.url);
                },
              ),
              IconButton(
                icon: Iconify(Mdi.alarm, size: 30, color: Colors.cyanAccent),
                color: Colors.amber,
                onPressed: () {
                  // Share.share(
                  //     'Check out this contest on ${widget.contest.name} on ${widget.contest.url}');
                },
              )
            ],
          )
        ],
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
