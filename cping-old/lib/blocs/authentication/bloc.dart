import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;

part 'event.dart';
part 'state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationStarted) {
        emit(AuthenticationLoading());

        final googleSignIn = GoogleSignIn(
          scopes: <String>[cal.CalendarApi.calendarScope],
        );

        try {
          final googleUser = await googleSignIn.signIn();

          if (googleUser == null) return;

          final googleAuth = await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);

          emit(AuthenticationSuccess());
        } catch (e) {
          emit(AuthenticationFailure());
          debugPrint(e.toString());
        }
      } else if (event is AuthenticationLogOut) {
        final googleSignIn = GoogleSignIn();
        await googleSignIn.disconnect();
        FirebaseAuth.instance.signOut();
        emit(AuthenticationLogout());
      }
    });
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
