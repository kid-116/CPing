import 'package:cp_ing/blocs/atcoder/bloc/atcoder_bloc.dart';
import 'package:cp_ing/blocs/codechef/bloc/codechef_bloc.dart';
import 'package:cp_ing/blocs/codeforces/bloc/codeforces_bloc.dart';
import 'package:cp_ing/pages/atcoder.dart';
import 'package:cp_ing/pages/codechef.dart';
import 'package:cp_ing/pages/codeforces.dart';

import '../blocs/authentication/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  title: Text('CODEFORCES'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<CodeforcesBloc>(context),
                        child: CodeforcesPage(),
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
                    title: Text('CODECHEF'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<CodechefBloc>(context),
                          child: CodechefPage(),
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
                  title: const Text('ATCODER'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<AtcoderBloc>(context),
                        child: AtcoderPage(),
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
                  title: const Text("LOGOUT"),
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
            title: const Text('HOME'),
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
                  )
                ],
              )),
        );
      },
    );
  }
}
