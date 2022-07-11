import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/colors.dart';
import '../config/theme.dart';
import '../widgets/contest_card.dart';
import '../blocs/website/bloc.dart';
import '../models/contest.dart';

Expanded listContests(List<Contest> contests, bool isOutDated) {
  return Expanded(
    child: Column(
      children: [
        isOutDated ? const LinearProgressIndicator() : Container(),
        Expanded(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: contests.length,
              itemBuilder: (context, index) {
                return ContestCard(contest: contests[index]);
              }),
        ),
      ],
    ),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: darkTheme.colorScheme.background,
          child: Column(children: <Widget>[
            Container(
              padding: const  EdgeInsets.fromLTRB(24, 40, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white)
                  ),
                  Text(
                    widget.name.toUpperCase(),
                    style: darkTheme.textTheme.headline1
                  )
                ],
              ),
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
                }
                if (state is ErrorState) {
                  debugPrint(state.error.toString());
                  return Center(child: Text(state.error));
                } else if (state is ContestsLoadedState) {
                  List<Contest> contests = state.contests;
                  if (state.isOutdated) {
                    BlocProvider.of<WebsiteBloc>(context)
                        .add(RefreshContestsEvent());
                  }
                  return contests.isNotEmpty
                      ? listContests(contests, state.isOutdated)
                      : noContests("No active contests to show!");
                } else if (state is RefreshedCacheState) {
                  BlocProvider.of<WebsiteBloc>(context).add(GetContestsEvent());
                }
                return const Center(
                  child: Text("Error: 404"),
                );
              },
            ),
          ]),
        ));
  }
}
