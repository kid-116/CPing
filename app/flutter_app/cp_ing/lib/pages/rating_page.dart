import 'package:cp_ing/blocs/website/bloc.dart';
import 'package:cp_ing/models/rating.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingPage extends StatefulWidget {
  RatingPage({Key? key}) : super(key: key);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: BlocBuilder<WebsiteBloc, WebsiteState>(
            builder: (context, state) {
              if (state is UserRatingsLoadedState) {
                return Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width - 40,
                  child: LineChart(
                    LineChartData(
                        backgroundColor: const Color(0xFF12175F),
                        minX: 0,
                        maxX: state.noofcontests + 1,
                        minY: state.minrating == 0 ? 0 : state.minrating - 100,
                        maxY: state.maxrating + 100,
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: const Color(0xff37434d), width: 1),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          drawHorizontalLine: false,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: const Color(0xff37434d),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        lineBarsData: [
                          LineChartBarData(colors: [
                            const Color(0xff23b6e6),
                            const Color(0xff02d39a),
                          ], spots: UserRatingsList(state.userRatings))
                        ]),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

List<FlSpot> UserRatingsList(List<UserRating> userrating) {
  List<FlSpot> ratingList = [];
  for (int i = 0; i < userrating.length; i++) {
    ratingList.add(FlSpot(i.toDouble(), userrating[i].oldRating.toDouble()));
  }
  return ratingList;
}
