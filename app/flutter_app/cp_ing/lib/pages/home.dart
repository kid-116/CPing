// pages
import 'package:cp_ing/pages/website.dart';
// blocs
import '../blocs/authentication/bloc.dart';
import '../blocs/website/bloc.dart';
import '../repositories/website.dart';
// flutter
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// firebase
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebsiteBloc codeforcesBloc = WebsiteBloc(
    initialState: WebsiteInitial(),
    repository: WebsiteRepository(
      endpoint: 'api/codeforces/contests'
    ),
  );

  WebsiteBloc atcoderBloc = WebsiteBloc(
    initialState: WebsiteInitial(),
    repository: WebsiteRepository(
        endpoint: 'api/atcoder/contests'
    ),
  );

  WebsiteBloc codechefBloc = WebsiteBloc(
    initialState: WebsiteInitial(),
    repository: WebsiteRepository(
        endpoint: 'api/codechef/contests'
    ),
  );

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                        ),
                        accountEmail: Text(
                          user!.email!,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                        accountName: Text(
                          user.displayName!,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 22),
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoURL!),
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  selectedTileColor: Colors.grey[700],
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[500],
                    child: const Icon(
                      Icons.assignment,
                      color: Colors.black,
                    ),
                  ),
                  title: const Text('Codeforces'),
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
                const Divider(), // add a line
                ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[500],
                      child: const Icon(
                        Icons.check_box_outlined,
                        color: Colors.black,
                      ),
                    ),
                    title: const Text('Codechef'),
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
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[500],
                    child: const Icon(
                      Icons.assignment,
                      color: Colors.black,
                    ),
                  ),
                  title: const Text('Atcoder'),
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
                const Divider(), // add a line
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[500],
                    child: const Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                  ),
                  title: const Text("Logout"),
                  onTap: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(AuthenticationLogOut());
                  },
                )
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Home'),
          ),
          body: Container(
              alignment: Alignment.center,
              color: Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Profile',
                  ),
                  const SizedBox(height: 32),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.displayName!,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email!,
                  ),
                  const SizedBox(height: 15),
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
