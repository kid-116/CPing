import 'package:cping/config/constants.dart';
import 'package:cping/config/theme.dart';
import 'package:cping/features/contests/domain/entities/contests.dart';
import 'package:cping/features/contests/presentation/bloc/contests_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/contest_card.dart';

Expanded listContests(List<Contest> contests) {
  return Expanded(
    child: Column(
      children: [
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
  final int platformId;

  const WebsitePage({
    Key? key,
    required this.platformId,
  }) : super(key: key);

  @override
  _WebsitePageState createState() => _WebsitePageState();
}

class _WebsitePageState extends State<WebsitePage> {
  @override
  void initState() {
    BlocProvider.of<ContestsBloc>(context)
        .add(GetContestsEvent(platformId: widget.platformId));
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
              Text(platformMapping[widget.platformId].toString().toUpperCase(),
                  style: darkTheme.textTheme.headline1)
            ],
          ),
        ),
        BlocConsumer<ContestsBloc, ContestsState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ContestsLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 200, horizontal: 0),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                )),
              );
            }
            if (state is ContestsError) {
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
            } else if (state is ContestsLoaded) {
              List<Contest> contests = state.contests;
              return contests.isNotEmpty
                  ? listContests(contests)
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
