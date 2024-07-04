// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_if_null_operators
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_track/models/attendance_model.dart';
import 'package:qr_track/models/course_model.dart';
import 'package:qr_track/models/user_model.dart';
import 'package:qr_track/res/colors.dart';
import 'package:qr_track/res/utility_functions.dart';
import 'package:qr_track/res/enums.dart';
import 'package:qr_track/views/courses_screens/course_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? ongoingCourse;
  List<Map<String, dynamic>>? coursesWithLecturesToday;
  String? currentQrId;

  Future<String> scanQr(String currentQrCodeID) async {
    String qrResult = 'Scanned Data Will Appear here';
    try {
      qrResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      setState(() {});
      return qrResult;
    } on PlatformException {
      qrResult = 'Failed to scan QR';
      return 'Failed to scan QR';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    if (UserModel.currentUser.userType == UserRoles.Teacher.name) {
      await CourseModel.fetchTeacherCourses();
    } else if (UserModel.currentUser.userType == UserRoles.Student.name) {
      await CourseModel.fetchStudentCourses();
    }
    coursesWithLecturesToday = await CourseModel.getCoursesWithLecturesToday();
    ongoingCourse = await CourseModel.getCurrentOngoingCourseWithLecture();
    print(ongoingCourse);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    'Welcome',
                  ),
                  subtitle: Text(
                    UserModel.currentUser.fullName ?? 'null',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.person_4, size: 60),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.1,
                  padding: EdgeInsets.only(top: 4, left: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      'Today is',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      UtilityFunctions.getWeekDayName(DateTime.now().weekday),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Ongoing Lecture",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                (ongoingCourse != null &&
                        ongoingCourse!['course'] != null &&
                        ongoingCourse!['lecture'] != null)
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('qrCode')
                            .doc('latestQrCode')
                            .snapshots(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return Center(
                              child: Text('No QR code data available'),
                            );
                          } else {
                            var qrCodeData = snapshot.data!.data();
                            if (qrCodeData == null) {
                              return Center(
                                child: Text('QR code data is null'),
                              );
                            }
                            return InkWell(
                              onTap: UserModel.currentUser.userType ==
                                      UserRoles.Student.name
                                  ? () {
                                      scanQr(qrCodeData['qrCodeId'])
                                          .then((value) {
                                        if (value == 'Failed to scan QR') {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Scan Failed'),
                                                  content: Text(
                                                      'Failed to scan QR Code'),
                                                );
                                              });
                                        } else if (value == "-1") {
                                          return;
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                if (qrCodeData['qrCodeId'] ==
                                                    value) {
                                                  AttendanceModel.addAttendance(
                                                    courseId:
                                                        ongoingCourse!['course']
                                                            ['courseId'],
                                                    lectureId: ongoingCourse![
                                                        'lecture']['lectureId'],
                                                    attendance: AttendanceModel(
                                                      studenName: UserModel
                                                          .currentUser.fullName,
                                                      rollNo: UserModel
                                                          .currentUser.rollNo,
                                                      time:
                                                          '${TimeOfDay.now()}',
                                                      day: UtilityFunctions
                                                          .getWeekDayName(
                                                              DateTime.now()
                                                                  .day),
                                                      date:
                                                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                                      status: AttendanceStatuses
                                                          .Present.name,
                                                    ),
                                                  );
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Attendance Marked Successfully'),
                                                  );
                                                } else {
                                                  return AlertDialog(
                                                    title:
                                                        Text('QR is expired'),
                                                  );
                                                }
                                              });
                                        }
                                      });
                                    }
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return CourseDetails(
                                                courseModel:
                                                    CourseModel.fromJson(
                                                        ongoingCourse![
                                                            'course']));
                                          },
                                        ),
                                      );
                                    },
                              child: Card(
                                color: AppColors.secondaryColor,
                                child: ListTile(
                                  title: Text(
                                    ongoingCourse!['course']['courseTitle'] ??
                                        '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${ongoingCourse!['course']['program'] ?? ''} ${ongoingCourse!['course']['department'] ?? ''} (Section: ${ongoingCourse!['course']['batch'] ?? ''} ${ongoingCourse!['course']['section'] ?? ''}) - (Room: ${ongoingCourse!['lecture']['roomLabel'] ?? ''}) ',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  trailing: Icon(
                                    UserModel.currentUser.userType ==
                                            UserRoles.Student.name
                                        ? Icons.qr_code
                                        : Icons.punch_clock,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                        }))
                    : Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text('No Ongoing Lecture'),
                      ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Today's Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                (coursesWithLecturesToday != null &&
                        coursesWithLecturesToday!.isNotEmpty)
                    ? Container(
                        padding: EdgeInsets.all(4),
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: Column(
                          children: coursesWithLecturesToday!.map((course) {
                            return LectureTile(
                              courseTitle:
                                  course['course']['courseTitle'] ?? '',
                              courseCode: course['course']['courseCode'] ?? '',
                              lectureTime:
                                  "${course['lecture']['startTime'] ?? ''}-${course['lecture']['endTime'] ?? ''} ", // You should populate lectureTime based on your logic
                              classLabel:
                                  "${course['course']['program'] ?? ''} ${course['course']['department'] ?? ''} ${course['course']['batch'] ?? ''} ${course['course']['section'] ?? ''}",
                            );
                          }).toList(),
                        ))
                    : Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text('No Lectures Today'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LectureTile extends StatelessWidget {
  const LectureTile({
    super.key,
    required this.courseTitle,
    required this.courseCode,
    required this.classLabel,
    required this.lectureTime,
  });

  final String? courseTitle;
  final String? courseCode;
  final String? classLabel;
  final String? lectureTime;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Text(
        '${courseTitle}\nCourse Code: ${courseCode ?? ''}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        classLabel ?? '',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: Text(
        lectureTime ?? '',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
