// pages
import 'package:cp_ing/calendar/client.dart';
import 'package:cp_ing/models/contest_hive.dart';
import 'package:cp_ing/pages/home.dart';
import 'package:cp_ing/pages/sign_in.dart';
// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// flutter packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
// blocs
import 'blocs/authentication/bloc.dart';
// hive
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// models
import 'models/contest.dart';
// calendar
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:googleapis/calendar/v3.dart' as cal;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(ContestHiveAdapter());
  await Hive.openBox('contests');

  // print('resetting hive boxes');
  // Hive.deleteFromDisk();

  runApp(const MyApp());

  // dynamic dy = DateTime.now();
  // print(dy);
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
                return const HomePage();
              } else {
                return const SignInPage();
              }
            }),
      ),
    );
  }
}
