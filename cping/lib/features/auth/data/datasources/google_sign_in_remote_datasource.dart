import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/error/exceptions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;

abstract class AuthRemoteDataSource {
  Future<bool> googleSignIn();
  Future<bool> logOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<bool> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>[cal.CalendarApi.calendarScope],
      ).signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } on SocketException {
      throw NetworkException();
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      print("Loggin out");
      await FirebaseAuth.instance.signOut();

      return true;
    } on SocketException {
      throw NetworkException();
    }
  }
}
