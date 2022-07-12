import 'package:cping/config/theme.dart';
import 'package:google_fonts/google_fonts.dart';

import '../blocs/authentication/bloc.dart';
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
        extendBodyBehindAppBar: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: darkTheme.colorScheme.background,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: Text(
                    "SIGN IN WITH GOOGLE",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: darkTheme.highlightColor,
                        letterSpacing: 2,
                        fontSize: 24,
                        fontWeight: FontWeight.w600
                    )
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(AuthenticationStarted());
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
          Text(
            "WELCOME",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Colors.white,
                letterSpacing: 4,
                fontSize: 26,
                fontWeight: FontWeight.w600
            ))
            ],
          ),
        )
    );
  }
}
