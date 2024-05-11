import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/theme.dart';
import '../widgets/contest_card.dart';
import '../blocs/website/bloc.dart';
import '../models/contest.dart';

Expanded listContests(List<Contest> contests, bool isOutDated) {
  return Expanded(
    child: Column(
      children: [
        isOutDated
            ? const Center(
                child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ))
            : Container(),
        SizedBox(
          height: isOutDated ? 10 : 0,
        ),
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
          padding: const EdgeInsets.fromLTRB(24, 40, 30, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
              Text(widget.name.toUpperCase(),
                  style: darkTheme.textTheme.displayLarge)
            ],
          ),
        ),
        BlocConsumer<WebsiteBloc, WebsiteState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is LoadingState) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 200, horizontal: 0),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                )),
              );
            }
            if (state is ErrorState) {
              debugPrint(state.error.toString());
              return const Expanded(
                child: Center(
                  child: Image(
                    image: AssetImage('assets/images/error.png'),
                    width: 250,
                    color: Color.fromRGBO(255, 255, 255, 0.3),
                    colorBlendMode: BlendMode.modulate,
                    // color: Colors.white.withOpacity(0.3),
                  ),
                ),
              );
            } else if (state is ContestsLoadedState) {
              List<Contest> contests = state.contests;
              if (state.isOutdated) {
                BlocProvider.of<WebsiteBloc>(context)
                    .add(RefreshContestsEvent());
              }
              return contests.isNotEmpty
                  ? listContests(contests, state.isOutdated)
                  : const Expanded(
                      child: Center(
                        child: Image(
                          image: AssetImage('assets/images/empty.png'),
                          width: 300,
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                          colorBlendMode: BlendMode.modulate,
                          // color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    );
            } else if (state is RefreshedCacheState) {
              BlocProvider.of<WebsiteBloc>(context).add(GetContestsEvent());
            }
            return const Expanded(
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/error.png'),
                  width: 250,
                  color: Color.fromRGBO(255, 255, 255, 0.3),
                  colorBlendMode: BlendMode.modulate,
                  // color: Colors.white.withOpacity(0.3),
                ),
              ),
            );
          },
        ),
      ]),
    ));
  }
}
