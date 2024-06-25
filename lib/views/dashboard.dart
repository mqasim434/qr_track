// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:qr_track/res/enums.dart';
import 'package:qr_track/views/more_screen.dart';
import 'package:qr_track/views/courses_screen.dart';
import 'package:qr_track/views/dashboard_screen.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> screensList = [
    DashboardScreen(),
    CoursesScreen(),
    MoreScreen(),
  ];

  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
            controller: pageController,
            allowImplicitScrolling: false,
            children: screensList),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(
                20,
              ),
            ),
          ),
          child: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                currentIndex = index;
                pageController.animateToPage(
                  index,
                  duration: Duration(microseconds: 20),
                  curve: Curves.ease,
                );
              });
            },
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_online),
                label: 'Courses',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
