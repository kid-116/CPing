import 'package:cp_ing/config/colors.dart';
import 'package:flutter/material.dart';

class MyTab extends StatefulWidget {
  final String label;
  final int index;
  final Function notifyBar;
  final bool active;

  const MyTab({
    Key? key,
    required this.label,
    required this.index,
    required this.notifyBar,
    required this.active,
  }) : super(key: key);

  @override
  _MyTabState createState() => _MyTabState();
}

class _MyTabState extends State<MyTab> {

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: InkWell(
        onTap: () {
          widget.notifyBar(widget.index);
        },
        child: Container(
            decoration: BoxDecoration(
                color: widget.active
                    ? MyColors.deepBlue
                    : MyColors.navyBlue
            ),
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      color: MyColors.cyan,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  )
              ),
            )
        ),
      ),
    );
  }
}

class MyTabBar extends StatefulWidget {
  final List<String> labels;
  final List<Function> callbacks;
  final int initBar;

  const MyTabBar({
    Key ? key,
    required this.labels,
    required this.callbacks,
    required this.initBar,
  }) : super(key: key);

  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  late int activeBar = widget.initBar;

  void changeTab(int index) {
    setState(() {
      activeBar = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    List<MyTab> tabs = List.generate(widget.labels.length, (index) =>
        MyTab(
            active: index == activeBar,
            index: index,
            label: widget.labels[index],
            notifyBar: (index) {
              changeTab(index);
              widget.callbacks[index]();
            }
        )
    );

    return Row(
      children: tabs,
    );
  }
}
