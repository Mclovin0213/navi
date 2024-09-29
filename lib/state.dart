import 'package:flutter/material.dart';
import 'package:navi/widgets/path.dart';
import 'package:string_to_color/string_to_color.dart';

class MyAppState extends ChangeNotifier {
  var paths = <Path>[];

  List<Color> indicatorColors = List.filled(17, Colors.black);
  List<Color> beforeLineColors = List.filled(17, Colors.black);
  List<Color> afterLineColors = List.filled(17, Colors.black);

  void addPath(Path newPath) {
    paths.add(newPath);
    updateColors(newPath);
    notifyListeners();
  }

  void updatePath(Path oldPath, Path newPath) {
    int index = paths.indexOf(oldPath);

    paths[index].pathType = newPath.pathType;
    paths[index].pathName = newPath.pathName;
    paths[index].pathStart = newPath.pathStart;
    paths[index].pathStartIndex = newPath.pathStartIndex;
    paths[index].pathEnd = newPath.pathEnd;
    paths[index].pathEndIndex = newPath.pathEndIndex;
    paths[index].pathColor = newPath.pathColor;
    notifyListeners();
  }

  void updateColors(Path newPath) {
    Color newColor = ColorUtils.stringToColor(newPath.pathColor.toLowerCase());

    for(int i = newPath.pathStartIndex; i <= newPath.pathEndIndex; i++) {
      indicatorColors[i] = newColor;
    }
    for(int i = newPath.pathStartIndex; i < newPath.pathEndIndex; i++) {
      afterLineColors[i] = newColor;
    }
    for(int i = newPath.pathStartIndex + 1; i <= newPath.pathEndIndex; i++) {
      beforeLineColors[i] = newColor;
    }
  }

  void removeColors(Path? newPath) {
    if (newPath == null) {
      return;
    }
    Color newColor = Colors.black;

    for(int i = newPath.pathStartIndex; i <= newPath.pathEndIndex; i++) {
      indicatorColors[i] = newColor;
    }
    for(int i = newPath.pathStartIndex; i < newPath.pathEndIndex; i++) {
      afterLineColors[i] = newColor;
    }
    for(int i = newPath.pathStartIndex + 1; i <= newPath.pathEndIndex; i++) {
      beforeLineColors[i] = newColor;
    }
  }

  Path? findPathByTime(TimeOfDay time) {
    for (Path path in paths) {
      if (path.pathStart.hour < time.hour ||
          (path.pathStart.hour == time.hour && path.pathStart.minute <= time.minute)) {
        if (path.pathEnd.hour > time.hour ||
            (path.pathEnd.hour == time.hour && path.pathStart.minute >= time.minute)) {
          return path;
        }
      }
    }
    return null;
  }

}