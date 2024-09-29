import 'package:flutter/material.dart';
import 'package:navi/widgets/add_page.dart';
import 'package:navi/widgets/edit_page.dart';
import 'package:navi/widgets/timeline_page.dart';

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