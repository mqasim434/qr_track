import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_track/models/user_model.dart';
import 'package:qr_track/res/enums.dart';
import 'package:qr_track/res/utility_functions.dart';

class AttendanceModel {
  String? attendanceId;
  String? studenName;
  String? rollNo;
  String? time;
  String? date;
  String? day;
  String? status;

  AttendanceModel({
    this.attendanceId,
    this.studenName,
    this.rollNo,
    this.time,
    this.date,
    this.day,
    this.status,
  });

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    attendanceId = json['attendanceId'];
    studenName = json['studenName'];
    rollNo = json['rollNo'];
    time = json['time'];
    date = json['date'];
    date = json['day'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attendanceId'] = attendanceId;
    data['studenName'] = studenName;
    data['rollNo'] = rollNo;
    data['time'] = time;
    data['date'] = date;
    data['day'] = date;
    data['status'] = status;
    return data;
  }

  static Future<String> addAttendance({
    required String courseId,
    required String lectureId,
    required AttendanceModel attendance,
  }) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('attendances')
          .doc(courseId)
          .collection('lectures')
          .doc(lectureId)
          .collection('attendances')
          .where('rollNo', isEqualTo: attendance.rollNo)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection('attendances')
            .doc(courseId)
            .collection('lectures')
            .doc(lectureId)
            .collection('attendances')
            .add(attendance.toJson());
        print('Attendance added successfully!');
        if (attendance.status == AttendanceStatuses.Absent.name) {
          return 'Attendance marked as Absent to to late Check In';
        } else {
          return 'Attendance marked as Present';
        }
      } else {
        print(
            'Attendance already marked for roll number: ${attendance.rollNo}');
        return 'Attendance already marked for roll number: ${attendance.rollNo}';
      }
    } catch (e) {
      print('Error adding attendance: $e');
      return 'Error adding attendance: $e';
    }
  }

  static Future<void> markAbsentees({
    required String courseId,
    required String lectureId,
    required List<StudentModel> allStudents,
  }) async {
    try {
      final markedAttendance = await FirebaseFirestore.instance
          .collection('attendances')
          .doc(courseId)
          .collection('lectures')
          .doc(lectureId)
          .collection('attendances')
          .get();

      final markedRollNos = markedAttendance.docs
          .map((doc) => doc.data()['rollNo'] as String)
          .toSet();

      final absentees = allStudents
          .where((student) => !markedRollNos.contains(student.rollNo))
          .toList();

      for (final student in absentees) {
        final attendance = AttendanceModel(
          studenName: student.fullName,
          rollNo: student.rollNo,
          time: 'N/A',
          day: UtilityFunctions.getWeekDayName(DateTime.now().day),
          date:
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
          status: AttendanceStatuses.Absent.name,
        );

        await AttendanceModel.addAttendance(
          courseId: courseId,
          lectureId: lectureId,
          attendance: attendance,
        );
      }

      print('Absentees marked successfully!');
    } catch (e) {
      print('Error marking absentees: $e');
    }
  }
}
