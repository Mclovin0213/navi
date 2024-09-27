import 'package:flutter/material.dart';
import 'package:navi/state.dart';
import 'package:provider/provider.dart';

import 'PathForm.dart';

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