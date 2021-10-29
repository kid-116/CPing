import 'package:cp_ing/config/colors.dart';
import 'package:cp_ing/widgets/contest_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/website/bloc.dart';
import '../models/contest.dart';
import 'package:cp_ing/widgets/tab_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Expanded listContests(List<Contest> contests) {
  return Expanded(
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: contests.length,
        itemBuilder: (context, index) {
          return ContestCard(contest: contests[index]);
        }),
  );
}

Widget noContests(String msg) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Text(
      msg,
      style: const TextStyle(
          fontSize: 24,
          color: Colors.grey,
          fontFamily: 'Roboto',
          fontStyle: FontStyle.italic),
      // textAlign: TextAlign.left,
    ),
  );
}

class WebsitePage extends StatefulWidget {
  final String name;
  const WebsitePage({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  _WebsitePageState createState() => _WebsitePageState();
}

class _WebsitePageState extends State<WebsitePage> {
  dynamic isrefreshed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.deepBlue,
          title: Text(
            "${widget.name} Contests",
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          actions: [
            !isrefreshed
                ? IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      WidgetsBinding.instance!
                          .addPostFrameCallback((_) => setState(() {
                                isrefreshed = true;
                              }));
                      setState(() {
                        print(isrefreshed);
                        isrefreshed = true;
                      });
                      print(isrefreshed);

                      BlocProvider.of<WebsiteBloc>(context)
                          .add(RefreshContestsEvent());

                      WidgetsBinding.instance!
                          .addPostFrameCallback((_) => setState(() {
                                isrefreshed = false;
                              }));

                      // ignore: unrelated_type_equality_checks
                      BlocProvider.of<WebsiteBloc>(context).state ==
                              ActiveContestsEventStateCache
                          ? BlocProvider.of<WebsiteBloc>(context)
                              .add(ActiveContestsEventCache())
                          : BlocProvider.of<WebsiteBloc>(context)
                              .add(FutureContestsEventCache());
                    },
                  )
                : const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: SpinKitWave(
                      color: Colors.white,
                      size: 10,
                    )),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_two.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(children: <Widget>[
            MyTabBar(
              labels: const ['ACTIVE', 'FUTURE'],
              callbacks: [activeContests, futureContests],
              initBar: 1,
            ),
            BlocConsumer<WebsiteBloc, WebsiteState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is LoadingState) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 100, horizontal: 0),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: MyColors.cyan,
                    )),
                  );
                } else if (state is ActiveLoadedState) {
                  List<Contest> activeContests = [];
                  activeContests = state.contests;
                  return activeContests.isNotEmpty
                      ? listContests(activeContests)
                      : noContests("No active contests to show!");
                } else if (state is FutureLoadedState) {
                  List<Contest> futureContests = [];
                  futureContests = state.contests;
                  return futureContests.isNotEmpty
                      ? listContests(futureContests)
                      : noContests("No future contests to show!");
                } else if (state is ErrorState) {
                  debugPrint(state.error.toString());
                  return Center(child: Text(state.error));
                } else if (state is ActiveContestsEventStateCache) {
                  List<Contest> activeContests = [];
                  activeContests = state.contests;
                  return activeContests.isNotEmpty
                      ? listContests(activeContests)
                      : noContests("No active contests to show!");
                } else if (state is FutureContestsEventStateCache) {
                  List<Contest> futureContests = [];
                  futureContests = state.contests;
                  return futureContests.isNotEmpty
                      ? listContests(futureContests)
                      : noContests("No future contests to show!");
                }
                return const Center(
                  child: Text("error 404"),
                );
              },
            ),
          ]),
        ));
  }

  void futureContests() {
    BlocProvider.of<WebsiteBloc>(context).add(FutureContestsEventCache());
  }

  void activeContests() {
    BlocProvider.of<WebsiteBloc>(context).add(ActiveContestsEventCache());
  }
}
