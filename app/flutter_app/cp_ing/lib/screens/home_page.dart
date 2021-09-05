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
          appBar: AppBar(
            title: Text('Logged In'),
            actions: [
              TextButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(AuthenticationLogOut());
                  },
                  child: Text("Log out",
                      style: TextStyle(color: Colors.white, fontSize: 18)))
            ],
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
                    backgroundImage: NetworkImage(user!.photoURL!),
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
