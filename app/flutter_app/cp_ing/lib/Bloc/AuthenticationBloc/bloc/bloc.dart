import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part '../../AuthenticationBloc/bloc/event.dart';
part 'state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield AuthenticationLoading();

      final googleSignIn = GoogleSignIn();
      GoogleSignInAccount? _user;
      // GoogleSignInAccount get user => _user!;
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
