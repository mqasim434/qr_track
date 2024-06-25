// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_track/res/colors.dart';
import 'package:qr_track/res/utility_functions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
                    'M. Qasim',
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
                InkWell(
                  onTap: () {
                    scanQr().then((value) {});
                  },
                  child: Card(
                    color: AppColors.secondaryColor,
                    child: ListTile(
                      title: Text(
                        'Programming Fundamentals',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(
                        'BS Software Engineering (Section; B)',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.qr_code,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
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
                Container(
                  padding: EdgeInsets.all(4),
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Column(
                    children: [
                      LectureTile(
                        courseTitle: "Programming Fundamentals",
                        courseCode: "IT 110",
                        lectureTime: "11:15 AM",
                        classLabel: "BS SE 19 B",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(),
                      ),
                      LectureTile(
                        courseTitle: "Programming Fundamentals",
                        courseCode: "IT 110",
                        lectureTime: "11:15 AM",
                        classLabel: "BS SE 19 B",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(),
                      ),
                      LectureTile(
                        courseTitle: "Programming Fundamentals",
                        courseCode: "IT 110",
                        lectureTime: "11:15 AM",
                        classLabel: "BS SE 19 B",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(),
                      ),
                      LectureTile(
                        courseTitle: "Programming Fundamentals",
                        courseCode: "IT 110",
                        lectureTime: "11:15 AM",
                        classLabel: "BS SE 19 B",
                      ),
                    ],
                  ),
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
        'Programming Fundamentals\nCourse Code: ${courseCode.toString()}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        'BS Software Engineering (Section; B)',
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
