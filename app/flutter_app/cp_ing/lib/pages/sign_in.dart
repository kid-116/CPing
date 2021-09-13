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
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/bg_one.jpg'),
            fit: BoxFit.fill,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(14, 245, 225, 1)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(30, 15, 30, 15)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                  ),
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(AuthenticationStarted());
                  },
                  child: const Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color.fromRGBO(32, 27, 50, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  )),
              const SizedBox(height: 50),
              const Center(
                child: Image(
                  image: AssetImage('assets/images/google.png'),
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sign In with Google",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontFamily: 'Kaisei',
                ),
              ),
            ],
          ),
        )
    );
  }
}
