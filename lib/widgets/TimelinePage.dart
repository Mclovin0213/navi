import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navi/constants.dart';
import 'package:provider/provider.dart';
import 'package:string_to_color/string_to_color.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:navi/state.dart';
import 'Path.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    var nowTime = TimeOfDay.now();
    var roundedTime = TimeOfDay(hour: nowTime.hour, minute: 0);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      var scrollPosition = scrollController.position;
      var pixelsToScroll = (Constants.times.indexOf(roundedTime) * 170).toDouble();
      scrollPosition.animateTo(
        pixelsToScroll,
        duration: const Duration(milliseconds: 6000),
        curve: Curves.easeInOutCubicEmphasized,
      );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var indicatorColors = appState.indicatorColors;
    var beforeColors = appState.beforeLineColors;
    var afterColors = appState.afterLineColors;
    var now = DateTime.now();
    var formattedTime = DateFormat('hh:mm a').format(now);

    Path? currentPath = appState.findPathByTime(TimeOfDay.now());
    var pathColor = Colors.black;
    var pathType = '';
    var pathName = '';

    if(currentPath != null) {
      pathColor = ColorUtils.stringToColor(currentPath.pathColor.toLowerCase());
      pathType = currentPath.pathType;
      pathName = currentPath.pathName;
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
          ),
          SizedBox(
              height: 200,
              child: Column(
                children: [
                  Text(
                      formattedTime,
                      style: TextStyle(
                          color: pathColor,
                          fontSize: 60
                      )
                  ),
                  Text(
                    pathName,
                    style: TextStyle(
                        color: pathColor,
                        fontSize: 30
                    ),
                  ),
                  Text(
                    pathType,
                    style: TextStyle(
                      color: pathColor,
                    ),
                  )
                ],
              )
          ),
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                itemCount: Constants.times.length,
                itemBuilder: (context, index) {
                  return TimelineTile(
                    isFirst: index == 0 ? true : false,
                    isLast: index == Constants.times.length - 1 ? true : false,
                    axis: TimelineAxis.horizontal,
                    alignment: TimelineAlign.center,
                    startChild: Container(
                      width: 175,
                    ),
                    endChild: SizedBox(
                        width: 175,
                        child: Column(
                          children: [
                            Center(
                                child: Text(Constants.times[index].format(context))
                            ),
                          ],
                        )
                    ),
                    indicatorStyle: IndicatorStyle(
                        color: indicatorColors[index]
                    ),
                    afterLineStyle: LineStyle(
                        color: afterColors[index]
                    ),
                    beforeLineStyle: LineStyle(
                        color: beforeColors[index]
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}