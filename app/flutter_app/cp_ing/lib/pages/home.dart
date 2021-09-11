// pages
import 'package:cp_ing/pages/website.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// blocs
import '../blocs/authentication/bloc.dart';
import '../blocs/website/bloc.dart';
import '../repositories/website.dart';
// flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// firebase
import 'package:firebase_auth/firebase_auth.dart';

WebsiteBloc createWebsiteBloc(String endpoint) {
  return WebsiteBloc(
    initialState: WebsiteInitial(),
    repository: WebsiteRepository(
        endpoint: endpoint
    ),
  );
}

const cyan = Color.fromRGBO(14, 245, 225, 1);
const deepBlue = Color.fromRGBO(32, 27, 50, 1);

TextStyle drawerOptionTextStyle() {
  return const TextStyle(
      color: Colors.white,
      fontSize: 20,
      // fontFamily: 'Roboto'
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
              color: deepBlue,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: UserAccountsDrawerHeader(
                          decoration: const BoxDecoration(
                            color: deepBlue,
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
                                color: Colors.white70,
                                fontSize: 22
                            ),
                          ),
                          currentAccountPicture: CircleAvatar(
                            backgroundImage: NetworkImage(user.photoURL!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const Divider(color: Colors.white),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15
                    ),
                    child: const Text(
                      'WEBSITES',
                      style: TextStyle(
                        color: cyan,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  // const Divider(color: Colors.white),
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: codeforcesBloc,
                          // value: BlocProvider.of<WebsiteBloc>(context),
                          child: page
                        ),
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: codechefBloc,
                            // value: BlocProvider.of<WebsiteBloc>(context),
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: atcoderBloc,
                          // value: BlocProvider.of<WebsiteBloc>(context),
                          child: const WebsitePage(
                            name: 'Atcoder',
                          ),
                        ),
                      ));
                    },
                  ),
                  // const SizedBox(height: 270),
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
            backgroundColor: deepBlue,
            title: const Text(
              'Home',
              style: TextStyle(
                color: Colors.white
              ),
            ),
            foregroundColor: const Color.fromRGBO(32, 27, 50, 1),
          ),
          body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_two.jpg'),
                  fit: BoxFit.fitWidth,
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
                  // FloatingActionButton(
                  //     onPressed: () async {
                  //       // final authHeaders = await user.authHeaders;
                  //       // final client = GoogleAuthClient(authHeaders);
                  //       // CalendarClient.calendar = cal.CalendarApi(client);
                  //       var client = CalendarClient();
                  //       var event = await client.insert(
                  //         title: '',
                  //         startTime: DateTime.parse("2021-09-09 12:00:00"),
                  //         endTime: DateTime.parse("2021-09-09 13:00:00"),
                  //       );
                  //       print(event['id']);
                  //     },
                  //     child: Text('Add'),
                  // ),
                  // FloatingActionButton(
                  //   onPressed: () async {
                  //     var client = CalendarClient();
                  //     var event = await client.modify(
                  //       id: 'b982uic2bl5nsv0kvkn1tgrje4',
                  //       title: 'Test',
                  //       startTime: DateTime.parse("2021-09-09 12:30:00"),
                  //       endTime: DateTime.parse("2021-09-09 13:00:00"),
                  //     );
                  //     print(event['id']);
                  //   },
                  //   child: Text('Modify'),
                  // ),
                  // FloatingActionButton(
                  //   onPressed: () async {
                  //     var client = CalendarClient();
                  //     var event = await client.delete('b982uic2bl5nsv0kvkn1tgrje4');
                  //   },
                  //   child: Text('Del'),
                  // ),
                ],
              )
          ),
        );
      },
    );
  }
}
