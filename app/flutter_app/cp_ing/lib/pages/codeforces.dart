import 'package:cp_ing/blocs/codeforces/bloc/bloc.dart';
import 'package:cp_ing/models/codeforces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          title: Text("CODEFORCES CONTESTS"),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          SizedBox(
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
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
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
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
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
          Divider(
            color: Colors.black,
          ),
          SizedBox(
            height: 30,
          ),
          BlocBuilder<CodeforcesBloc, CodeforcesState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ActiveLoadedState) {
                List<CodeforcesModel> _listCurrent = [];
                _listCurrent = state.listContest;
                // _list_future = state.list_future;
                return _listCurrent.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _listCurrent.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Column(children: <Widget>[
                                  Text(_listCurrent[index].contest[0].name),
                                  Text(_listCurrent[index].contest[0].length),
                                  Text(_listCurrent[index].contest[0].start),
                                ]),
                              );
                            }),
                      )
                    : Center(child: Text("No Active Contests"));
              } else if (state is FutureLoadedState) {
                List<CodeforcesModel> _listCurrent = [];
                _listCurrent = state.listContest;
                return _listCurrent.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _listCurrent.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Column(children: <Widget>[
                                  Text(_listCurrent[index].contest[0].name),
                                  Text(_listCurrent[index].contest[0].length),
                                  Text(_listCurrent[index].contest[0].start),
                                ]),
                              );
                            }),
                      )
                    : Center(child: Text("No Future Contests"));
              } else if (state is ErrorState) {
                print(state.error.toString());
                return Center(child: Text(state.error));
              }
              return Center(
                child: Text("error 404"),
              );
            },
          ),
        ]));
  }

  void futureContests() {
    BlocProvider.of<CodeforcesBloc>(context).add(FutureContestEvent());
  }

  void activeContests() {
    BlocProvider.of<CodeforcesBloc>(context).add(ActiveContestEvent());
  }
}