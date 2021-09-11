import 'package:cp_ing/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/website/bloc.dart';
import '../models/contest.dart';
import 'package:intl/intl.dart';
import 'package:cp_ing/widgets/tab_bar.dart';

class ListContests extends StatelessWidget {
  final List<Contest> contests;

  const ListContests({
    Key? key,
    required this.contests
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime dateTime) {
      return DateFormat('E, d MMM y - H:mm').format(dateTime);
    }

    String formatLength(Duration length) {
      int strLen = length.toString().length;

      return length.toString().substring(0, strLen - 10);
    }

    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: contests.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(10),
              child: Column(children: <Widget>[
                Text(contests[index].name),
                Text(formatLength(contests[index].length)),
                Text(formatDate(contests[index].start)),
                Text(formatDate(contests[index].end)),
                Text(contests[index].id)
              ]),
            );
          }),
    );
  }
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
        body: Column(children: <Widget>[
          MyTabBar(
            labels: const ['ACTIVE', 'FUTURE'],
            callbacks: [activeContests, futureContests],
            initBar: 0,
          ),
          const SizedBox(
            height: 30,
          ),
          BlocBuilder<WebsiteBloc, WebsiteState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ActiveLoadedState) {
                List<Contest> activeContests = [];
                activeContests = state.contests;
                return activeContests.isNotEmpty
                    ? ListContests(contests: activeContests)
                    : const Center(child: Text("No active contests"));
              } else if (state is FutureLoadedState) {
                List<Contest> futureContests = [];
                futureContests = state.contests;
                return futureContests.isNotEmpty
                    ? ListContests(contests: futureContests)
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
        ]));
  }

  void futureContests() {
    BlocProvider.of<WebsiteBloc>(context).add(FutureContestsEvent());
  }

  void activeContests() {
    BlocProvider.of<WebsiteBloc>(context).add(ActiveContestsEvent());
  }
}