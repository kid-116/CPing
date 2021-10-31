import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_ing/config/colors.dart';
import 'package:cp_ing/firestore/user_data.dart';
import 'package:cp_ing/models/contest.dart';
import 'package:cp_ing/pages/website.dart';
import 'package:cp_ing/widgets/contest_card.dart';
import '../blocs/authentication/bloc.dart';
import '../blocs/website/bloc.dart';
import '../repositories/website.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

WebsiteBloc createWebsiteBloc(String endpoint) {
  return WebsiteBloc(
    initialState: WebsiteInitial(),
    repository: WebsiteRepository(endpoint: endpoint),
  );
}

TextStyle drawerOptionTextStyle() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 20,
  );
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
          if (contest.end.isBefore(DateTime.now())) {
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
            : noContests("You haven't registered for any contests yet!");
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
            // backgroundColor: deepBlue,
            child: Container(
              color: MyColors.deepBlue,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: UserAccountsDrawerHeader(
                          decoration: const BoxDecoration(
                            color: MyColors.deepBlue,
                          ),
                          accountEmail: Text(
                            user!.email!,
                            style: const TextStyle(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 16,
                            ),
                          ),
                          accountName: Text(
                            user.displayName!,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 22),
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
                    child: const Text(
                      'WEBSITES',
                      style: TextStyle(
                        color: MyColors.cyan,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  ListTile(
                    selectedTileColor: Colors.white10,
                    leading: const Image(
                      image: AssetImage('assets/images/codeforces_icon.png'),
                      height: 35,
                      width: 35,
                    ),
                    title: Text(
                      'Codeforces',
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
                        image: AssetImage('assets/images/codechef_icon.png'),
                        height: 35,
                        width: 35,
                      ),
                      title: Text(
                        'Codechef',
                        style: drawerOptionTextStyle(),
                      ),
                      onTap: () {
                        codechefBloc.add(GetContestsEvent());
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: codechefBloc,
                            child: const WebsitePage(
                              name: 'Codechef',
                            ),
                          ),
                        ));
                      }),
                  ListTile(
                    leading: const Image(
                      image: AssetImage('assets/images/atcoder_icon.png'),
                      color: Colors.white,
                      height: 35,
                      width: 35,
                    ),
                    title: Text(
                      'Atcoder',
                      style: drawerOptionTextStyle(),
                    ),
                    onTap: () {
                      atcoderBloc.add(GetContestsEvent());
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: atcoderBloc,
                          child: const WebsitePage(
                            name: 'Atcoder',
                          ),
                        ),
                      ));
                    },
                  ),
                  const Divider(color: Colors.white),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[500],
                            child: const Icon(
                              Icons.logout,
                              color: Colors.black,
                            ),
                          ),
                          title: Text(
                            'Logout',
                            style: drawerOptionTextStyle(),
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
            backgroundColor: MyColors.deepBlue,
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
            foregroundColor: const Color.fromRGBO(32, 27, 50, 1),
          ),
          body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_two.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 35, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Hello,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 65,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        user.displayName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  listRegisteredContests(),
                ],
              )),
        );
      },
    );
  }
}
