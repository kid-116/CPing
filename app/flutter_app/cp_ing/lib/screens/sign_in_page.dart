import 'package:cp_ing/Bloc/Authentication_bloc/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Authentication'),
          actions: [
            TextButton(
              onPressed: () => BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLogOut()),
              child: Text("logout ", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Sign in with google'),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationStarted());
            },
          ),
        ));
  }
}
