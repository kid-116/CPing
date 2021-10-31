import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cp_ing/config/colors.dart';
import 'package:cp_ing/firestore/cache.dart';
import 'package:cp_ing/widgets/contest_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/website/bloc.dart';
import '../models/contest.dart';
import 'package:cp_ing/widgets/tab_bar.dart';

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

  @override
  void initState() {
    checkLastUpdate();
    super.initState();
  }

  Future<bool> checkLastUpdate() async {
    await CacheDatabase.getLastUpdated(site: widget.name.toLowerCase())
        .then((lastUpdated) {
          debugPrint(lastUpdated.toString());
      if (Timestamp.now().seconds - lastUpdated.seconds >= 300) {
        debugPrint("outdated cache");
        BlocProvider.of<WebsiteBloc>(context).add(RefreshContestsEvent());
        return true;
      }
      return false;
    });
    return false;
  }

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
                } if (state is ErrorState) {
                  debugPrint(state.error.toString());
                  return Center(child: Text(state.error));
                } else if (state is ActiveContestsEventState) {
                  List<Contest> activeContests = [];
                  activeContests = state.contests;
                  return activeContests.isNotEmpty
                      ? listContests(activeContests)
                      : noContests("No active contests to show!");
                } else if (state is FutureContestsEventState) {
                  List<Contest> futureContests = [];
                  futureContests = state.contests;
                  return futureContests.isNotEmpty
                      ? listContests(futureContests)
                      : noContests("No future contests to show!");
                } else if (state is RefreshedCacheState) {
                  if(state.currentTab == 'A') {
                    activeContests();
                  }
                  else {
                    futureContests();
                  }
                }
                return const Center(
                  child: Text("Error: 404"),
                );
              },
            ),
          ]),
        ));
  }

  void futureContests() {
    BlocProvider.of<WebsiteBloc>(context).add(FutureContestsEvent());
  }

  void activeContests() {
    BlocProvider.of<WebsiteBloc>(context).add(ActiveContestsEvent());
  }
}
