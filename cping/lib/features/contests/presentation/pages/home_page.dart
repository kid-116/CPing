import 'package:cping/config/theme.dart';
import 'package:cping/features/auth/data/datasources/google_sign_in_remote_datasource.dart';
import 'package:cping/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cping/features/auth/domain/usecases/log_out.dart';
import 'package:cping/features/contests/presentation/pages/website_page.dart';
import 'package:cping/features/contests/presentation/widgets/registered_contest_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle drawerOptionTextStyle() {
  return GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: darkTheme.colorScheme.secondary,
      letterSpacing: 2);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final LogOut logOut =
      LogOut(AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()));
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: Drawer(
        child: Container(
          // padding: const EdgeInsets.only(top: 20),
          color: darkTheme.colorScheme.background.withOpacity(1),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: darkTheme.colorScheme.background.withOpacity(0),
                      ),
                      accountEmail: Text(
                        user!.email!,
                        style: GoogleFonts.poppins(
                            color: darkTheme.colorScheme.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      accountName: Text(
                        user.displayName!,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(user.photoURL!),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  'WEBSITES',
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: darkTheme.highlightColor,
                      letterSpacing: 2.5),
                  textAlign: TextAlign.justify,
                ),
              ),
              ListTile(
                selectedTileColor: Colors.white10,
                leading: const Image(
                  image: AssetImage('assets/images/codeforces_icon.png'),
                  height: 45,
                  width: 45,
                ),
                title: Text(
                  'CODEFORCES',
                  style: drawerOptionTextStyle(),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const WebsitePage(
                            platformId: 1,
                          )));
                },
              ),
              ListTile(
                  leading: const Image(
                    image: AssetImage('assets/images/cc_icon.png'),
                    height: 45,
                    width: 45,
                  ),
                  title: Text(
                    'CODECHEF',
                    style: drawerOptionTextStyle(),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const WebsitePage(
                              platformId: 2,
                            )));
                  }),
              ListTile(
                leading: const Image(
                  image: AssetImage('assets/images/atcoder_icon.png'),
                  color: Colors.white,
                  height: 45,
                  width: 45,
                ),
                title: Text(
                  'ATCODER',
                  style: drawerOptionTextStyle(),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const WebsitePage(
                            platformId: 3,
                          )));
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title: Text(
                        'LOGOUT',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 3),
                      ),
                      onTap: () {
                        logOut(Params()).then((value) {
                          value.fold((l) => print("Error"),
                              (r) => print("Success logout"));
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        // backgroundColor: const Color.fromRGBO(32, 27, 50, 1),
        backgroundColor: darkTheme.colorScheme.background,
        // elevation: 0,
        title: Text(
          'Home'.toUpperCase(),
          style: darkTheme.textTheme.headline1,
        ),
      ),
      body: Container(
          color: darkTheme.colorScheme.background,
          alignment: Alignment.center,
          child: Stack(children: [
            // Positioned(
            //     bottom: -5,
            //     right: -0.584 * MediaQuery.of(context).size.width / 2,
            //     child: Opacity(
            //       opacity: 0.6,
            //       child: Image.asset(
            //         "assets/images/robot.png",
            //         scale: 5.0,
            //       ),
            //     )),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Hello!',
                          style: GoogleFonts.damion(
                            color: Colors.white,
                            fontSize: 54,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(user.displayName!,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 54,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  listRegisteredContests(),
                ],
              ),
            ),
          ])),
    );
  }
}
