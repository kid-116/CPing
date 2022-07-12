import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/theme.dart';
import '../firestore/user_data.dart';
import '../models/contest.dart';
import '../pages/website.dart';
import '../widgets/contest_card.dart';
import '../blocs/authentication/bloc.dart';
import '../blocs/website/bloc.dart';
import '../repositories/website.dart';

WebsiteBloc createWebsiteBloc(String endpoint) {
  return WebsiteBloc(
    initialState: WebsiteInitial(),
    repository: WebsiteRepository(endpoint: endpoint),
  );
}

TextStyle drawerOptionTextStyle() {
  return GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: darkTheme.colorScheme.secondary,
      letterSpacing: 2);
}

Expanded listRegisteredContests() {
  return Expanded(
    child: StreamBuilder(
      stream: UserDatabase.readContests(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        final collection = snapshot.data?.docs;

        List<Contest> contests = <Contest>[];

        collection?.forEach((json) {
          final length = Duration(
            days: json['length']['days'],
            hours: json['length']['hours'],
            minutes: json['length']['minutes'],
          );
          final DateTime start = DateTime.parse(json['start']).toLocal();
          Contest contest = Contest(
            calendarId: json['calendarId'],
            name: json['name'],
            start: start,
            end: start.add(length),
            length: length,
            docId: json.id,
          );
          if (contest.end.isBefore(DateTime.now()) ||
              contest.calendarId == 'null') {
            UserDatabase.deleteContest(docId: contest.docId);
          } else {
            contests.add(contest);
          }
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebsiteBloc codeforcesBloc = createWebsiteBloc('api/codeforces/contests');
  WebsiteBloc atcoderBloc = createWebsiteBloc('api/atcoder/contests');
  WebsiteBloc codechefBloc = createWebsiteBloc('api/codechef/contests');

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          drawer: Drawer(
            child: Container(
              // padding: const EdgeInsets.only(top: 20),
              color: darkTheme.colorScheme.background.withOpacity(1),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color:
                                darkTheme.colorScheme.background.withOpacity(0),
                          ),
                          accountEmail: Text(
                            user!.email!,
                            style: GoogleFonts.poppins(
                                color: darkTheme.colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          accountName: Text(
                            user.displayName!,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                          currentAccountPicture: CircleAvatar(
                            backgroundImage: NetworkImage(user.photoURL!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Text(
                      'WEBSITES',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: darkTheme.highlightColor,
                          letterSpacing: 2.5),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  ListTile(
                    selectedTileColor: Colors.white10,
                    leading: const Image(
                      image: AssetImage('assets/images/codeforces_icon.png'),
                      height: 45,
                      width: 45,
                    ),
                    title: Text(
                      'CODEFORCES',
                      style: drawerOptionTextStyle(),
                    ),
                    onTap: () {
                      WebsitePage page = const WebsitePage(
                        name: 'Codeforces',
                      );
                      codeforcesBloc.add(GetContestsEvent());
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                            value: codeforcesBloc, child: page),
                      ));
                    },
                  ),
                  ListTile(
                      leading: const Image(
                        image: AssetImage('assets/images/cc_icon.png'),
                        height: 45,
                        width: 45,
                      ),
                      title: Text(
                        'CODECHEF',
                        style: drawerOptionTextStyle(),
                      ),
                      onTap: () {
                        codechefBloc.add(GetContestsEvent());
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: codechefBloc,
                            child: const WebsitePage(
                              name: 'CodeChef',
                            ),
                          ),
                        ));
                      }),
                  ListTile(
                    leading: const Image(
                      image: AssetImage('assets/images/atcoder_icon.png'),
                      color: Colors.white,
                      height: 45,
                      width: 45,
                    ),
                    title: Text(
                      'ATCODER',
                      style: drawerOptionTextStyle(),
                    ),
                    onTap: () {
                      atcoderBloc.add(GetContestsEvent());
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: atcoderBloc,
                          child: const WebsitePage(
                            name: 'AtCoder',
                          ),
                        ),
                      ));
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          title: Text(
                            'LOGOUT',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 3),
                          ),
                          onTap: () {
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(AuthenticationLogOut());
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            // backgroundColor: const Color.fromRGBO(32, 27, 50, 1),
            backgroundColor: darkTheme.colorScheme.background,
            // elevation: 0,
            title: Text(
              'Home'.toUpperCase(),
              style: darkTheme.textTheme.headline1,
            ),
          ),
          body: Container(
              color: darkTheme.colorScheme.background,
              alignment: Alignment.center,
              child: Stack(children: [
                Positioned(
                    bottom: -5,
                    right: -0.584 * MediaQuery.of(context).size.width / 2,
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        "assets/images/robot.png",
                        scale: 5.0,
                      ),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Hello!',
                              style: GoogleFonts.damion(
                                color: Colors.white,
                                fontSize: 54,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(user.displayName!,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 54,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                      listRegisteredContests(),
                    ],
                  ),
                ),
              ])),
        );
      },
    );
  }
}
