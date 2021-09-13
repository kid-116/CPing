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
// blocs
import 'blocs/authentication/bloc.dart';
// hive
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// models
// calendar
import 'package:flutter/widgets.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // var user = await FirebaseAuth.instance.currentUser!;
  // print(user.email);
  await Hive.initFlutter();
  Hive.registerAdapter(ContestHiveAdapter());

  // await Hive.openBox('shash.sm2003@gmail.com');

  // print('resetting hive boxes');
  // Hive.deleteFromDisk();

  runApp(const MyApp());

  // dynamic dy = DateTime.now();
  // print(dy);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  Future<int> temp(String email) async {
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
                  future: temp(FirebaseAuth.instance.currentUser!.email!),
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
