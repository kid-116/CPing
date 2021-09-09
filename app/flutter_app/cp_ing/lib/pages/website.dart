import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/website/bloc.dart';
import '../models/contest.dart';

class CodeforcesPage extends StatefulWidget {
  const CodeforcesPage({Key? key}) : super(key: key);

  @override
  _CodeforcesPageState createState() => _CodeforcesPageState();
}

class _CodeforcesPageState extends State<CodeforcesPage> {
  bool activeContest = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Codeforces Contests"),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => activeContests(),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    height: 100,
                    width: 150,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                          child: Text(
                        "Active Contests",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )),
                    )),
              ),
              InkWell(
                onTap: () => futureContests(),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    height: 100,
                    width: 150,
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                          child: Text(
                        "Future Contests",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )),
                    )),
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
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
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: activeContests.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(children: <Widget>[
                                  Text(activeContests[index].name),
                                  Text(activeContests[index].length),
                                  Text(activeContests[index].start),
                                ]),
                              );
                            }),
                      )
                    : const Center(child: Text("No Active Contests"));
              } else if (state is FutureLoadedState) {
                List<Contest> futureContests = [];
                futureContests = state.contests;
                return futureContests.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: futureContests.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(children: <Widget>[
                                  Text(futureContests[index].name),
                                  Text(futureContests[index].length),
                                  Text(futureContests[index].start),
                                ]),
                              );
                            }),
                      )
                    : const Center(child: Text("No Future Contests"));
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