import 'package:cping/features/auth/data/datasources/google_sign_in_remote_datasource.dart';
import 'package:cping/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cping/features/auth/domain/usecases/googlesignin.dart';
import 'package:cping/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn(
      AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: darkTheme.colorScheme.background,
          child: Stack(clipBehavior: Clip.antiAlias, children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text("SIGN IN WITH GOOGLE",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: darkTheme.highlightColor,
                            letterSpacing: 2,
                            fontSize: 24,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      googleSignIn(Params()).then((value) {
                        value.fold(
                            (l) => print("Error"), (r) => print("Success"));
                      });
                    },
                    child: const Image(
                      image: AssetImage('assets/images/google.png'),
                      height: 50,
                      width: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("WELCOME",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          letterSpacing: 4,
                          fontSize: 26,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Positioned(
                bottom: -5,
                right: -0.584 * MediaQuery.of(context).size.width / 2,
                child: Opacity(
                  opacity: 0.6,
                  child: Image.asset(
                    "assets/images/robot.png",
                    scale: 5.0,
                  ),
                )),
          ]),
        ));
  }
}
