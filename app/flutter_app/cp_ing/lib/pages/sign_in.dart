import '../blocs/authentication/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      // appBar: AppBar(
      //   title: const Text('CPing'),
      //   elevation: 0.1,
      //   backgroundColor: Colors.tealAccent[400],
      // ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_one.jpg'),
            fit: BoxFit.fill,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10.0),
            //   child: const Image(
            //     image: AssetImage('assets/images/cp_ing.png'),
            //     height: 150,
            //     width: 150,
            //   ),
            // ),
            const SizedBox(height: 50,),
             TextButton(
               style: ButtonStyle(
                 backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(14, 245, 225, 1)),
                 padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(30, 15, 30, 15)),
                 shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
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
                )
            ),
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
            // const SizedBox(height: 200),
            // const Divider(color: Colors.tealAccent,),
            // const SizedBox(height: 20,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ClipRRect(
            //       borderRadius: BorderRadius.circular(5),
            //       child: const Image(
            //         image: AssetImage('assets/images/codechef_icon.png'),
            //         height: 80,
            //         colorBlendMode: BlendMode.darken,
            //       ),
            //     ),
            //     const SizedBox(width: 25,),
            //     ClipRRect(
            //       borderRadius: BorderRadius.circular(5),
            //       child: const Image(
            //         image: AssetImage('assets/images/codeforces_icon.png'),
            //         height: 80,
            //         width: 80,
            //       ),
            //     ),
            //     const SizedBox(width: 25,),
            //     ClipRRect(
            //       borderRadius: BorderRadius.circular(5),
            //       child: const Image(
            //         color: Colors.white,
            //         image: AssetImage('assets/images/atcoder_icon.png'),
            //         height: 80,
            //         width: 80,
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
      )
    );
  }
}
