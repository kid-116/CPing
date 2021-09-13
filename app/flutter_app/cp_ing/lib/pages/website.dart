import 'package:cp_ing/config/colors.dart';
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
      }
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
              initBar: 0,
            ),
            BlocBuilder<WebsiteBloc, WebsiteState>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ActiveLoadedState) {
                  List<Contest> activeContests = [];
                  activeContests = state.contests;
                  return activeContests.isNotEmpty
                      ? listContests(activeContests)
                      : const Center(child: Text("No active contests"));
                } else if (state is FutureLoadedState) {
                  List<Contest> futureContests = [];
                  futureContests = state.contests;
                  return futureContests.isNotEmpty
                      ? listContests(futureContests)
                      : const Center(child: Text("No future contests"));
                } else if (state is ErrorState) {
                  print(state.error.toString());
                  return Center(child: Text(state.error));
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
    BlocProvider.of<WebsiteBloc>(context).add(FutureContestsEvent());
  }

  void activeContests() {
    BlocProvider.of<WebsiteBloc>(context).add(ActiveContestsEvent());
  }
}