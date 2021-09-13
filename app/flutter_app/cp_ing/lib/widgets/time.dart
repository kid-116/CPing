import 'package:cp_ing/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Time extends StatelessWidget {
  final DateTime time;

  const Time({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // child: Text(time.toString()),
        child: Column(
          children: [
            Text(
              DateFormat('H:mm').format(time),
              // textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 32,
                fontStyle: FontStyle.italic,
                color: MyColors.cyan,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time.day.toString(),
                  style: const TextStyle(
                    fontSize: 52,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    // Text(time.month.toString()),
                    Text(
                      DateFormat('MMM').format(time),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontFamily: 'Kaisei',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(
                      height: 5
                    ),
                    Text(
                      time.year.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
