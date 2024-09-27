import 'package:flutter/material.dart';
import 'package:navi/widgets/Path.dart';
import 'package:navi/constants.dart';
import 'package:provider/provider.dart';

import '../state.dart';

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