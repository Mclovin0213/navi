import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

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

  static const List<String> types = <String>['Project', 'Event', 'Task'];
  static const List<TimeOfDay> times = <TimeOfDay>[
    TimeOfDay(hour: 8, minute: 00),
    TimeOfDay(hour: 9, minute: 00),
    TimeOfDay(hour: 10, minute: 00),
    TimeOfDay(hour: 11, minute: 00),
    TimeOfDay(hour: 12, minute: 00),
    TimeOfDay(hour: 13, minute: 00),
    TimeOfDay(hour: 14, minute: 00),
    TimeOfDay(hour: 15, minute: 00),
    TimeOfDay(hour: 16, minute: 00),
    TimeOfDay(hour: 17, minute: 00),
    TimeOfDay(hour: 18, minute: 00),
    TimeOfDay(hour: 19, minute: 00),
    TimeOfDay(hour: 20, minute: 00),
    TimeOfDay(hour: 21, minute: 00),
    TimeOfDay(hour: 22, minute: 00),
    TimeOfDay(hour: 23, minute: 00),
    TimeOfDay(hour: 0, minute: 00),
  ];

  static const List<Color> colors = <Color>[
    Colors.deepPurple,
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.pink
  ];


  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String typeValue = AddPage.types.first;
    TimeOfDay startTimeValue = AddPage.times.first;
    TimeOfDay endTimeValue = AddPage.times[1];
    Color color = AddPage.colors.first;

    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField(
                value: typeValue,
                items: AddPage.types.map<DropdownMenuItem<String>>((String value) {
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
                items: AddPage.times.map<DropdownMenuItem<TimeOfDay>>((TimeOfDay value) {
                  return DropdownMenuItem<TimeOfDay>(
                    value: value,
                    child: Text(value.format(context)),
                  );
                }).toList(),
                onChanged: (TimeOfDay? value) {
                  setState(() {
                    startTimeValue = value!;
                  });
                }
              ),
              DropdownButtonFormField(
                icon: Icon(Icons.access_time),
                value: endTimeValue,
                items: AddPage.times.map<DropdownMenuItem<TimeOfDay>>((TimeOfDay value) {
                  return DropdownMenuItem<TimeOfDay>(
                    value: value,
                    child: Text(value.format(context)),
                  );
                }).toList(),
                onChanged: (TimeOfDay? value) {
                  setState(() {
                    endTimeValue = value!;
                  });
                }
              ),
              DropdownButtonFormField(
                  icon: Icon(Icons.color_lens_outlined),
                  value: color,
                  items: AddPage.colors.map<DropdownMenuItem<Color>>((Color value) {
                    return DropdownMenuItem<Color>(
                      value: value,
                      child: Text(value.toString())
                    );
                  }).toList(),
                  onChanged: (Color? value) {
                    setState(() {
                      color = value!;
                    });
                  }
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {

                  }
                },
                child: Text('Submit')
              )
            ],
          ),
        ),
      )
    );
  }
}


class TimelinePage extends StatelessWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        TimelineTile(
          axis: TimelineAxis.horizontal,
          alignment: TimelineAlign.center,
          isFirst: true,
        ),
      ]
    );
  }
}

class Path {
  final String pathType;
  final String pathName;
  final String pathDesc;
  final TimeOfDay pathStart;
  final TimeOfDay pathEnd;

  Path({
    required this.pathType,
    required this.pathName,
    required this.pathDesc,
    required this.pathStart,
    required this.pathEnd,
  });
}

