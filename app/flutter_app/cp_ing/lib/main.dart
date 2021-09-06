// pages
import 'package:cp_ing/Repositories/codeforces_repository.dart';
import 'package:cp_ing/pages/home.dart';
import 'package:cp_ing/pages/sign_in.dart';
// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// flutter packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// blocs
import 'Repositories/codechef_repository.dart';
import 'blocs/authentication/bloc.dart';
import 'blocs/codechef/bloc/codechef_bloc.dart';
import 'blocs/codeforces/bloc/codeforces_bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider<CodechefBloc>(
          create: (context) => CodechefBloc(
              initialState: CodechefInitial(),
              repository: CodechefRepository()),
        ),
        BlocProvider<CodeforcesBloc>(
          create: (context) => CodeforcesBloc(
              initialState: CodeforcesInitial(),
              repository: CodeforcesRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CPing',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              } else if (snapshot.hasData) {
                return const HomePage();
              } else {
                return const SignInPage();
              }
            }),
      ),
    );
  }
}
