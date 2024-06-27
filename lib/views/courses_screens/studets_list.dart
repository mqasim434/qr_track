// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:qr_track/models/user_model.dart';

class StudentsList extends StatelessWidget {
  StudentsList({super.key, required this.studentsData});

  List<StudentModel> studentsData;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Students List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: studentsData.isEmpty
          ? Center(
              child: Text('No Student Found'),
            )
          : ListView.builder(
              itemCount: studentsData.length,
              itemBuilder: (context, index) {
                StudentModel student = studentsData[index];
                return ListTile(
                  title: Text(student.fullName.toString()),
                  subtitle: Text(student.rollNo.toString()),
                );
              }),
    ));
  }
}
