import 'dart:async';
import 'package:http/http.dart' as http;
// packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// sign-in
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// calendar
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:cp_ing/calendar/client.dart';

part 'event.dart';
part 'state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield AuthenticationLoading();

      final googleSignIn = GoogleSignIn(
        scopes: <String>[cal.CalendarApi.calendarScope],
      );

      GoogleSignInAccount? _user;
      try {
        final googleUser = await googleSignIn.signIn();

        if (googleUser == null) return;

        _user = googleUser;
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        // calendar
        final authHeaders = await googleUser.authHeaders;
        final client = GoogleAuthClient(authHeaders);
        CalendarClient.calendar = cal.CalendarApi(client);

        yield AuthenticationSuccess();
      } catch (e) {
        yield AuthenticationFailure();
        print(e.toString());
      }
    } else if (event is AuthenticationLogOut) {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
      yield AuthenticationLogout();
    }
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
