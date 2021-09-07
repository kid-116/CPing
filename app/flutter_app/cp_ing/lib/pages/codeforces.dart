import 'package:cp_ing/blocs/codeforces/bloc/codeforces_bloc.dart';
import 'package:cp_ing/blocs/codeforces/bloc/codeforces_bloc.dart';
import 'package:cp_ing/models/codeforces_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeforcesPage extends StatefulWidget {
  const CodeforcesPage({Key? key}) : super(key: key);

  @override
  _CodeforcesPageState createState() => _CodeforcesPageState();
}

class _CodeforcesPageState extends State<CodeforcesPage> {
  bool active_contest = true;
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
                onTap: () => active_contests(),
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
                onTap: () => future_contests(),
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
                List<CodeforcesModel> _list_current = [];
                _list_current = state.list_contest;
                // _list_future = state.list_future;
                return _list_current.length != 0
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _list_current.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Column(children: <Widget>[
                                  Text(_list_current[index].Contest[0].name),
                                  Text(_list_current[index].Contest[0].length),
                                  Text(_list_current[index].Contest[0].start),
                                ]),
                              );
                            }),
                      )
                    : Center(child: Text("No Active Contests"));
              } else if (state is FutureLoadedState) {
                List<CodeforcesModel> _list_current = [];
                _list_current = state.list_contest;
                return _list_current.length > 0
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _list_current.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Column(children: <Widget>[
                                  Text(_list_current[index].Contest[0].name),
                                  Text(_list_current[index].Contest[0].length),
                                  Text(_list_current[index].Contest[0].start),
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

  void future_contests() {
    BlocProvider.of<CodeforcesBloc>(context).add(Future_contest_event());
  }

  void active_contests() {
    BlocProvider.of<CodeforcesBloc>(context).add(Active_contest_event());
  }
}


// BlocBuilder<CodeforcesBloc, CodeforcesState>(
//         builder: (context, state) {
//           if (state is LoadingState) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is LoadedState) {
//             List<CodechefModel> _list_present = [], _list_future = [];
//             _list_present = state.list_present;
//             _list_future = state.list_future;
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: _list_present.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: EdgeInsets.all(10),
//                           child: Column(children: <Widget>[
//                             Text(_list_present[index].Contest[0].name),
//                             Text(_list_present[index].Contest[0].code),
//                             Text(_list_present[index].Contest[0].length),
//                             Text(_list_present[index].Contest[0].start),
//                           ]),
//                         );
//                       }),
//                 ),
//                 Divider(
//                   color: Colors.black,
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: _list_future.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: EdgeInsets.all(10),
//                           child: Column(children: <Widget>[
//                             Text(_list_future[index].Contest[0].name),
//                             Text(_list_future[index].Contest[0].code),
//                             Text(_list_future[index].Contest[0].length),
//                             Text(_list_future[index].Contest[0].start),
//                           ]),
//                         );
//                       }),
//                 ),
//               ],
//             );
//           } else if (state is ErrorState) {
//             print(state.error.toString());
//             return Center(child: Text(state.error));
//           }
//           return Center(
//             child: Text("error 404"),
//           );
//         },
//       ),