import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:string_to_color/string_to_color.dart';
import 'package:uuid/uuid.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        home: SignInPage(),
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailTEC = TextEditingController();
  TextEditingController _passwordTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _emailTEC,
                    decoration: InputDecoration(
                      hintText: 'Enter Email'
                    )
                  ),
                  TextField(
                    controller: _passwordTEC,
                    decoration: InputDecoration(
                      hintText: 'Enter Password'
                    ),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                            email: _emailTEC.text,
                            password: _passwordTEC.text)
                          .then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage())
                            );
                          }).onError((error, stackTrace) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text('Sign In Failed'),
                                    content: Text('Wrong Email/Password'),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK')
                                      )
                                    ]
                                );
                              }
                            );
                      });
                    },
                    child: Text(
                      'LOG IN'
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                        },
                        child: const Text('Sign Up')
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _userNameTEC = TextEditingController();
  TextEditingController _emailTEC = TextEditingController();
  TextEditingController _passwordTEC = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up"
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                      controller: _userNameTEC,
                      decoration: InputDecoration(
                          hintText: 'Enter Username'
                      )
                  ),
                  TextField(
                      controller: _emailTEC,
                      decoration: InputDecoration(
                          hintText: 'Enter Email'
                      )
                  ),
                  TextField(
                    controller: _passwordTEC,
                    decoration: InputDecoration(
                        hintText: 'Enter Password'
                    ),
                    obscureText: true,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                            email: _emailTEC.text,
                            password: _passwordTEC.text)
                          .then((value) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        }).onError((error, stackTrace){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text('Sign Up Failed'),
                                    content: Text('Try Again'),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK')
                                      )
                                    ]
                                );
                              }
                          );
                        });
                      },
                      child: Text(
                          'Sign Up'
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class MyAppState extends ChangeNotifier {
  final DatabaseReference pathsRef = FirebaseDatabase.instance.ref().child('paths');



  var paths = <Path>[];

  List<Color> indicatorColors = List.filled(17, Colors.black);
  List<Color> beforeLineColors = List.filled(17, Colors.black);
  List<Color> afterLineColors = List.filled(17, Colors.black);

  void addPath(Path newPath) {
    paths.add(newPath);
    updateColors(newPath);
    savePathsToFirebase(paths);
    notifyListeners();
  }

  void savePathsToFirebase(List<Path> paths) {
    final Map<String, dynamic> pathsMap = {};
    for (int i = 0; i < paths.length; i++) {
      pathsMap[i.toString()] = paths[i].toJson();
    }
    pathsRef.set(pathsMap);
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
    } else {
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
        page = EditPage();
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

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: PathForm(
            path: null,
          )
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

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var paths = appState.paths;

    return SafeArea(
      child: Column(
        children: [
          Text(
            'Paths',
            style: TextStyle(
              fontSize: 60
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: paths.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: ColorUtils.stringToColor(paths[index].pathColor.toLowerCase()),
                      ),
                      title: Text(paths[index].pathName),
                      trailing: Text('${paths[index].pathStart.format(context)}-${paths[index].pathEnd.format(context)}' ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PathForm(path: paths[index]),
                                  SizedBox(height: 16),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('Close'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PathForm extends StatefulWidget {
  final Path? path;

  const PathForm({Key? key, required this.path})
      : super(key: key);

  @override
  State<PathForm> createState() => _PathFormState();
}

class _PathFormState extends State<PathForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _pathNameTEC;
  late String typeValue;
  late TimeOfDay startTimeValue;
  late TimeOfDay endTimeValue;
  late String colorValue;
  late int startIndex;
  late int endIndex;

  @override
  void initState() {
    super.initState();
    _pathNameTEC = TextEditingController(text: widget.path?.pathName ?? '');
    typeValue = widget.path?.pathType ?? Constants.types.first;
    startTimeValue = widget.path?.pathStart ?? Constants.times.first;
    endTimeValue = widget.path?.pathEnd ?? Constants.times[1];
    colorValue = widget.path?.pathColor ?? Constants.colors.first;
    startIndex = widget.path?.pathStartIndex ?? 0;
    endIndex = widget.path?.pathEndIndex ?? 1;
  }

  @override
  void dispose() {
    _pathNameTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var oldPath = widget.path;

    return Material(
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
                    final path = Path(
                        pathType: typeValue,
                        pathName: _pathNameTEC.text,
                        pathStart: startTimeValue,
                        pathStartIndex: startIndex,
                        pathEnd: endTimeValue,
                        pathEndIndex: endIndex,
                        pathColor: colorValue
                    );
                    if (widget.path == null) {
                      appState.addPath(path);
                    } else {
                      appState.removeColors(oldPath);
                      appState.updateColors(path);
                      appState.updatePath(widget.path!, path);
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Success'),
                          content: Text('Path added successfully!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK')
                            )
                          ]
                        );
                      }
                    );
                  }
                },
                child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}



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
    required this.pathColor,
  }) : id = id ?? Uuid().v4();

  factory Path.fromJson(Map<String, dynamic> json) {
    return Path(
      id: json['id'],
      pathType: json['pathType'],
      pathName: json['pathName'],
      pathStart: TimeOfDay.fromDateTime(DateTime.parse(json['pathStart'])),
      pathStartIndex: json['pathStartIndex'],
      pathEnd: TimeOfDay.fromDateTime(DateTime.parse(json['pathEnd'])),
      pathEndIndex: json['pathEndIndex'],
      pathColor: json['pathColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pathType': pathType,
      'pathName': pathName,
      'pathStart': pathStart.toString(),
      'pathStartIndex': pathStartIndex,
      'pathEnd': pathEnd.toString(),
      'pathEndIndex': pathEndIndex,
      'pathColor': pathColor,
    };
  }

  @override
  String toString() {
    return '$pathType,\n $pathName,\n ${pathStart.toString()},\n ${pathStartIndex.toString()},\n ${pathEnd.toString()},\n ${pathEndIndex.toString()},\n $pathColor';
  }
}
