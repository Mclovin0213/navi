import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:string_to_color/string_to_color.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Navi',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomePage(),
      ),
    );
  }
}

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

  void updateColors(Path newPath) {
    for(int i = newPath.pathStartIndex; i <= newPath.pathEndIndex; i++) {
      indicatorColors[i] = ColorUtils.stringToColor(newPath.pathColor.toLowerCase());
    }
    for(int i = newPath.pathStartIndex; i < newPath.pathEndIndex; i++) {
      afterLineColors[i] = ColorUtils.stringToColor(newPath.pathColor.toLowerCase());
    }
    for(int i = newPath.pathStartIndex + 1; i <= newPath.pathEndIndex; i++) {
      beforeLineColors[i] = ColorUtils.stringToColor(newPath.pathColor.toLowerCase());
    }
  }

}

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = AddPage();
        break;
      case 1:
        page = TimelinePage();
        break;
      case 2:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Path'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline_outlined),
            label: 'Timeline'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Edit Paths'
          )
        ],
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
      body: page,
    );
  }
}

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _pathNameTEC = TextEditingController();
  TextEditingController _pathDescTEC = TextEditingController();

  String typeValue = Constants.types.first;
  TimeOfDay startTimeValue = Constants.times.first;
  TimeOfDay endTimeValue = Constants.times[1];
  String colorValue = Constants.colors.first;

  int startIndex = 0;
  int endIndex = 1;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonFormField(
                      value: typeValue,
                      items: Constants.types.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          typeValue = value!;
                        });
                      }
                  ),
                  TextFormField(
                    controller: _pathNameTEC,
                    decoration: const InputDecoration(
                      hintText: 'Name of path'
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _pathDescTEC,
                    decoration: const InputDecoration(
                        hintText: 'Short Description (optional)'
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                      icon: Icon(Icons.access_time),
                      value: startTimeValue,
                      items: Constants.times.map<DropdownMenuItem<TimeOfDay>>((TimeOfDay value) {
                        return DropdownMenuItem<TimeOfDay>(
                          value: value,
                          child: Text(value.format(context)),
                        );
                      }).toList(),
                      onChanged: (TimeOfDay? value) {
                        setState(() {
                          startTimeValue = value!;
                          startIndex = Constants.times.indexOf(value);
                        });
                      }
                  ),
                  DropdownButtonFormField(
                    icon: Icon(Icons.access_time),
                    value: endTimeValue,
                    items: Constants.times.map<DropdownMenuItem<TimeOfDay>>((TimeOfDay value) {
                      return DropdownMenuItem<TimeOfDay>(
                        value: value,
                        child: Text(value.format(context)),
                      );
                    }).toList(),
                    onChanged: (TimeOfDay? value) {
                      setState(() {
                        endTimeValue = value!;
                        endIndex = Constants.times.indexOf(value);
                      });
                    }
                  ),
                  DropdownButtonFormField(
                      value: colorValue,
                      items: Constants.colors.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          colorValue = value!;
                        });
                      }
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        appState.addPath(Path(
                          pathType: typeValue,
                          pathName: _pathNameTEC.text,
                          pathDesc: _pathDescTEC.text,
                          pathStart: startTimeValue,
                          pathStartIndex: startIndex,
                          pathEnd: endTimeValue,
                          pathEndIndex: endIndex,
                          pathColor: colorValue
                        ));
                      }
                    },
                    child: Text('Submit')
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var paths = appState.paths;
    var indicatorColors = appState.indicatorColors;
    var beforeColors = appState.beforeLineColors;
    var afterColors = appState.afterLineColors;


    return SafeArea(
      child: Column(
        children: [

          Flexible(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
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

class Path {
  final String pathType;
  final String pathName;
  final String pathDesc;
  final TimeOfDay pathStart;
  final int pathStartIndex;
  final TimeOfDay pathEnd;
  final int pathEndIndex;
  final String pathColor;

  Path({
    required this.pathType,
    required this.pathName,
    required this.pathDesc,
    required this.pathStart,
    required this.pathStartIndex,
    required this.pathEnd,
    required this.pathEndIndex,
    required this.pathColor,
  });

  @override
  String toString() {
    return '$pathType,\n $pathName,\n $pathDesc,\n ${pathStart.toString()},\n ${pathStartIndex.toString()},\n ${pathEnd.toString()},\n ${pathEndIndex.toString()},\n $pathColor';
  }
}
