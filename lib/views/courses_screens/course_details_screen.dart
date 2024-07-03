// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_track/models/course_model.dart';
import 'package:qr_track/models/user_model.dart';
import 'package:qr_track/res/colors.dart';
import 'package:qr_track/res/enums.dart';
import 'package:qr_track/views/courses_screens/studets_list.dart';

class CourseDetails extends StatefulWidget {
  CourseDetails({super.key, required this.courseModel});

  CourseModel courseModel;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  String? qrId;

  String getRandomQrId() {
    Random random = Random.secure();
    String id = 'qr-${random.nextInt(99999)}';
    updateQRCode(id);
    return id;
  }

  Future<void> updateQRCode(String qrCodeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('qrCode')
          .doc('latestQrCode')
          .set({'qrCodeId': qrCodeId}, SetOptions(merge: true)).then((_) {
        print("QR Code ID updated successfully!");
      }).catchError((error) {
        print("Failed to update QR Code ID: $error");
      });
    } catch (e) {
      print("Error updating QR Code ID: $e");
    }
  }

  @override
  void initState() {
    qrId = getRandomQrId();
    setState(() {});
    Timer.periodic(Duration(seconds: 10), (timer) {
      qrId = getRandomQrId();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: widget.courseModel.lectures!.isEmpty
            ? Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Course Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: Center(
                  child: Text('No Lectures Found'),
                ),
              )
            : DefaultTabController(
                length: widget.courseModel.lectures!.length,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Course Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    bottom: TabBar(
                        tabs: widget.courseModel.lectures!
                            .map((e) => Tab(
                                  text: e['lectureId'].toString(),
                                ))
                            .toList()),
                    centerTitle: true,
                  ),
                  body: TabBarView(
                    children: widget.courseModel.lectures!.map((e) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              InfoTile(
                                heading: 'Course Title',
                                value:
                                    widget.courseModel.courseTitle.toString(),
                              ),
                              Divider(),
                              InfoTile(
                                heading: 'Course Code',
                                value: widget.courseModel.courseCode.toString(),
                              ),
                              Divider(),
                              InfoTile(
                                heading: 'Credit Hours',
                                value:
                                    widget.courseModel.creditHours.toString(),
                              ),
                              Divider(),
                              InfoTile(
                                heading: 'Class',
                                value:
                                    '${widget.courseModel.program.toString()} ${widget.courseModel.department.toString()} ${widget.courseModel.batch.toString()} ${widget.courseModel.section.toString()}',
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Students',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      List<StudentModel> studentsList = widget
                                          .courseModel.students!
                                          .map((e) => e)
                                          .toList();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StudentsList(
                                            studentsData: studentsList,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'View',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    'Lectures:',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text('Lectures List'),
                                                content:
                                                    widget.courseModel.lectures!
                                                            .isEmpty
                                                        ? Text(
                                                            'No Lectures Found')
                                                        : SizedBox(
                                                            height: 100,
                                                            width: screenWidth,
                                                            child: ListView
                                                                .builder(
                                                                    itemCount: widget
                                                                        .courseModel
                                                                        .lectures!
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return ListTile(
                                                                        title: Text(
                                                                            'Lecture ${index + 1}'),
                                                                        subtitle:
                                                                            Text(
                                                                          '${widget.courseModel.lectures![index]['startTime']}-${widget.courseModel.lectures![index]['endTime']}-${widget.courseModel.lectures![index]['day']}',
                                                                        ),
                                                                        trailing:
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(Icons.close),
                                                                          onPressed:
                                                                              () {
                                                                            widget.courseModel.lectures!.removeAt(index);
                                                                            setState(() {});
                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                              ));
                                    },
                                    child: Text(
                                      'View',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text('Attendance: '),
                                  InkWell(
                                    onTap: () {},
                                    child: Text(
                                      'View',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              UserModel.currentUser.userType ==
                                      UserRoles.Teacher.name
                                  ? Text(
                                      'SCAN QR',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    )
                                  : SizedBox(),
                              UserModel.currentUser.userType ==
                                      UserRoles.Teacher.name
                                  ? SizedBox(
                                      width: screenWidth,
                                      height: screenHeight * 0.4,
                                      child: QrImageView(
                                        data:
                                            '$qrId ${e['lectureId']}  ${widget.courseModel.courseCode} ${widget.courseModel.department} ${widget.courseModel.section} ${widget.courseModel.batch} ${widget.courseModel.program}',
                                        version: QrVersions.auto,
                                        size: 200.0,
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ));
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.heading,
    required this.value,
  });

  final String? heading;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          heading.toString(),
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
