// pages
import 'package:cp_ing/models/contest_hive.dart';
import 'package:cp_ing/pages/home.dart';
import 'package:cp_ing/pages/sign_in.dart';
// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// flutter packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
// blocs
import 'blocs/authentication/bloc.dart';
// hive
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(ContestHiveAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  Future<int> openBox(String email) async {
    await Hive.openBox(email);
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
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
                  child: Text("Error"),
                );
              } else if (snapshot.hasData) {
                return FutureBuilder(
                  future: openBox(FirebaseAuth.instance.currentUser!.email!),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return const HomePage();
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              } else {
                return const SignInPage();
              }
            }),
      ),
    );
  }
}
