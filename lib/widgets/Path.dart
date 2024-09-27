import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// class Path {
//   final String id;
//   String pathType;
//   String pathName;
//   TimeOfDay pathStart;
//   int pathStartIndex;
//   TimeOfDay pathEnd;
//   int pathEndIndex;
//   String pathColor;
//
//   Path({
//     String? id,
//     required this.pathType,
//     required this.pathName,
//     required this.pathStart,
//     required this.pathStartIndex,
//     required this.pathEnd,
//     required this.pathEndIndex,
//     required this.pathColor,
//   }) : id = id ?? Uuid().v4();
//
//   factory Path.fromJson(Map<String, dynamic> json) {
//     return Path(
//       id: json['id'],
//       pathType: json['pathType'],
//       pathName: json['pathName'],
//       pathStart: TimeOfDay.fromDateTime(DateTime.parse(json['pathStart'])),
//       pathStartIndex: json['pathStartIndex'],
//       pathEnd: TimeOfDay.fromDateTime(DateTime.parse(json['pathEnd'])),
//       pathEndIndex: json['pathEndIndex'],
//       pathColor: json['pathColor'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'pathType': pathType,
//       'pathName': pathName,
//       'pathStart': pathStart.toString(),
//       'pathStartIndex': pathStartIndex,
//       'pathEnd': pathEnd.toString(),
//       'pathEndIndex': pathEndIndex,
//       'pathColor': pathColor,
//     };
//   }
//
//   @override
//   String toString() {
//     return '$pathType,\n $pathName,\n ${pathStart.toString()},\n ${pathStartIndex.toString()},\n ${pathEnd.toString()},\n ${pathEndIndex.toString()},\n $pathColor';
//   }
// }

class Path {
  final String id;
  String pathType;
  String pathName;
  TimeOfDay pathStart;
  int pathStartIndex;
  TimeOfDay pathEnd;
  int pathEndIndex;
  String pathColor;

  Path({
    String? id,
    required this.pathType,
    required this.pathName,
    required this.pathStart,
    required this.pathStartIndex,
    required this.pathEnd,
    required this.pathEndIndex,
    required this.pathColor
  }) : id = id ?? Uuid().v4();

  factory Path.fromMap(Map<String, dynamic> data) {
    return Path(
      id: data['id'],
      pathType: data['pathType'],
      pathName: data['pathName'],
      pathStart: data['pathStart'],
      pathStartIndex: data['pathStartIndex'],
      pathEnd: data['pathEnd'],
      pathEndIndex: data['pathEndIndex'],
      pathColor: data['pathColor']
    );
  }
}