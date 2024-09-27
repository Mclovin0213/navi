import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_to_color/string_to_color.dart';
import 'PathForm.dart';
import 'package:navi/state.dart';

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