import 'package:cp_ing/Bloc/Authentication_bloc/bloc/authentication_bloc.dart';
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
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        accountName: Text(
                          user.displayName!,
                          style: TextStyle(color: Colors.black, fontSize: 22),
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
                    child: Icon(
                      Icons.assignment,
                      color: Colors.black,
                    ),
                  ),
                  title: Text('CODECHEF'),
                  onTap: () {},
                ),
                Divider(), // add a line
                ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[500],
                      child: Icon(
                        Icons.check_box_outlined,
                        color: Colors.black,
                      ),
                    ),
                    title: Text('CODECHEF'),
                    onTap: () {}),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[500],
                    child: Icon(
                      Icons.assignment,
                      color: Colors.black,
                    ),
                  ),
                  title: Text('ATCODER'),
                  onTap: () {},
                ),
                Divider(), // add a line
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[500],
                    child: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                  ),
                  title: Text("LOGOUT"),
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
            title: Text('HOME'),
          ),
          body: Container(
              alignment: Alignment.center,
              color: Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Profile',
                  ),
                  SizedBox(height: 32),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user.displayName!,
                  ),
                  SizedBox(height: 8),
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
