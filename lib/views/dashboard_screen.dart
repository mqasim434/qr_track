// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_if_null_operators
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
  CourseModel? ongoingCourse;
  List<CourseModel>? coursesWithLecturesToday;

  Future<void> scanQr() async {
    String qrResult = 'Scanned Data Will Appear here';
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
    } on PlatformException {
      qrResult = 'Failed to scan QR';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    await CourseModel.fetchCourses();
    setState(() {
      ongoingCourse = CourseModel.getOngoingLecture(CourseModel.coursesList);
      coursesWithLecturesToday = CourseModel.getCoursesWithLecturesToday();
      print('Ongoing course: ${ongoingCourse?.courseTitle}');
    });
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
                    UserModel.currentUser.fullName != null
                        ? UserModel.currentUser.fullName
                        : 'null',
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
                ongoingCourse != null
                    ? InkWell(
                        onTap:
                            UserModel.currentUser.userType == UserRoles.Student
                                ? () {
                                    scanQr().then((value) {});
                                  }
                                : () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CourseDetails(
                                          courseModel:
                                              ongoingCourse as CourseModel);
                                    }));
                                  },
                        child: Card(
                          color: AppColors.secondaryColor,
                          child: ListTile(
                            title: Text(
                              ongoingCourse!.courseTitle.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            subtitle: Text(
                              '${ongoingCourse!.program.toString()} ${ongoingCourse!.department.toString()} (Section: ${ongoingCourse!.batch.toString()} ${ongoingCourse!.section.toString()}) - (Room: ) ',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            trailing: Icon(
                              UserModel.currentUser.userType ==
                                      UserRoles.Student
                                  ? Icons.qr_code
                                  : Icons.punch_clock,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Text('No Ongoing Lecture'),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Today's Shedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                coursesWithLecturesToday != null
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
                              courseTitle: course.courseTitle ?? '',
                              courseCode: course.courseCode ?? '',
                              lectureTime:
                                  '', // You should populate lectureTime based on your logic
                              classLabel:
                                  "${course.program ?? ''} ${course.department ?? ''} ${course.batch ?? ''} ${course.section ?? ''}",
                            );
                          }).toList(),
                        ))
                    : Text('No Lectures Today'),
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
        '${courseTitle}\nCourse Code: ${courseCode.toString()}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        classLabel.toString(),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: Text(
        '9:45 AM',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
