import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:qr_track/models/user_model.dart';

class CourseModel {
  String? courseId;
  String? courseTitle;
  String? courseCode;
  String? creditHours;
  String? instructorEmail;
  String? instructorName;
  String? department;
  String? section;
  String? batch;
  String? program;
  List<StudentModel>? students;
  List<Map<String, dynamic>>? lectures; // Added lectures field

  static List<CourseModel> coursesList = [];

  CourseModel(
      {this.courseId,
      this.courseTitle,
      this.courseCode,
      this.creditHours,
      this.instructorName,
      this.instructorEmail,
      this.department,
      this.section,
      this.batch,
      this.program,
      this.students,
      this.lectures}); // Updated constructor

  CourseModel.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    courseTitle = json['courseTitle'];
    courseCode = json['courseCode'];
    creditHours = json['creditHours'];
    instructorName = json['instructorName'];
    instructorEmail = json['instructorEmail'];
    department = json['department'];
    section = json['section'];
    batch = json['batch'];
    program = json['program'];
    if (json['students'] != null) {
      students = <StudentModel>[];
      json['students'].forEach((v) {
        students!.add(StudentModel.fromJson(v));
      });
    }
    if (json['lectures'] != null) {
      lectures = <Map<String, dynamic>>[];
      json['lectures'].forEach((v) {
        lectures!.add(Map<String, dynamic>.from(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['courseId'] = courseId;
    data['courseTitle'] = courseTitle;
    data['courseCode'] = courseCode;
    data['creditHours'] = creditHours;
    data['instructorEmail'] = instructorEmail;
    data['instructorName'] = instructorName;
    data['department'] = department;
    data['section'] = section;
    data['batch'] = batch;
    data['program'] = program;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    if (lectures != null) {
      data['lectures'] = lectures!;
    }
    return data;
  }

  //functions

  static Future<bool> addCourseToFirestore(
    String courseTitle,
    String courseCode,
    String creditHours,
    String instructorName,
    String instructorEmail,
    String department,
    String section,
    String batch,
    String program,
    List<StudentModel> students,
    List<Map<String, dynamic>> lectures,
  ) async {
    String courseId = generateRandomCourseId();
    // Create a CourseModel instance using dummy data
    CourseModel newCourse = CourseModel(
      courseId: courseId,
      courseTitle: courseTitle,
      courseCode: courseCode,
      creditHours: creditHours,
      instructorName: instructorName,
      instructorEmail: instructorEmail,
      department: department,
      section: section,
      batch: batch,
      program: program,
      students: students, // Add student data if necessary
      lectures: lectures, // Add lecture data if necessary
    );

    // Convert the CourseModel instance to JSON
    Map<String, dynamic> courseData = newCourse.toJson();

    // Add the course to the Firestore collection
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId) // Use courseId as document ID
        .set(courseData)
        .then((_) {
      print("Course added successfully!");
    }).catchError((error) {
      print("Failed to add course: $error");
      return false;
    });
    return true;
  }

  static Future<void> fetchCourses() async {
    try {
      EasyLoading.show(status: 'Loading');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('courses')
              .where(
                'instructorEmail',
                isEqualTo: UserModel.currentUser.email,
              )
              .get();
      coursesList.clear(); // Clear the list before adding new data
      querySnapshot.docs.forEach((doc) {
        coursesList.add(CourseModel.fromJson(doc.data()));
      });
      print('Courses fetched successfully: ${coursesList.length} courses');
    } catch (e) {
      print('Error fetching courses: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  bool isLectureOngoing(Map<String, dynamic> lecture) {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat("HH:mm"); // Assuming time is in HH:mm format

    DateTime startTime = format.parse(lecture['startTime']);
    DateTime endTime = format.parse(lecture['endTime']);

    // Adjust today's date to the time from lecture start and end times
    DateTime todayStartTime = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    DateTime todayEndTime =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    // Check if the current day matches the lecture day
    String todayDay = DateFormat('EEEE')
        .format(now); // Get current day as a string (e.g., "Monday")
    String lectureDay = lecture[
        'day']; // Assuming lecture contains a 'day' key with values like "Monday", "Tuesday", etc.

    return now.isAfter(todayStartTime) &&
        now.isBefore(todayEndTime) &&
        todayDay == lectureDay;
  }

  static CourseModel? getOngoingLecture(List<CourseModel> courses) {
    for (CourseModel course in courses) {
      if (course.lectures != null) {
        for (Map<String, dynamic> lecture in course.lectures!) {
          if (course.isLectureOngoing(lecture)) {
            return course;
          }
        }
      }
    }
    return null; // No ongoing lecture found
  }

  List<Map<String, dynamic>>? todaylectures; // Added lectures field

  // Define this method inside the CourseModel class
  bool hasLecturesToday() {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat("HH:mm"); // Assuming time is in HH:mm format

    String todayDay = DateFormat('EEEE').format(now); // Get current day as a string (e.g., "Monday")

    if (lectures != null) {
      for (Map<String, dynamic> lecture in lectures!) {
        if (lecture['day'] == todayDay) {
          return true;
        }
      }
    }
    return false;
  }

  static List<CourseModel> getCoursesWithLecturesToday() {
    List<CourseModel> coursesWithLecturesToday = [];

    for (CourseModel course in coursesList) {
      if (course.hasLecturesToday()) {
        coursesWithLecturesToday.add(course);
      }
    }

    return coursesWithLecturesToday;
  }

}




String generateRandomCourseId() {
  String courseId = 'course-';
  Random random = Random();
  int min = 1000;
  int max = 9999;
  int id = min + random.nextInt(max - min + 1);

  courseId = courseId + id.toString();

  return courseId;
}
