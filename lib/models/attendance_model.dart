import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  String? attendanceId;
  String? studenName;
  String? rollNo;
  String? time;
  String? date;
  String? status;

  AttendanceModel({
    this.attendanceId,
    this.studenName,
    this.rollNo,
    this.time,
    this.date,
    this.status,
  });

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    attendanceId = json['attendanceId'];
    studenName = json['studenName'];
    rollNo = json['rollNo'];
    time = json['time'];
    date = json['date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attendanceId'] = attendanceId;
    data['studenName'] = studenName;
    data['rollNo'] = rollNo;
    data['time'] = time;
    data['date'] = date;
    data['status'] = status;
    return data;
  }

  static void addAttendance(String courseId, String lectureId, AttendanceModel attendance) async {
  try {
    
    DocumentReference lectureRef = FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('lectures')
        .doc(lectureId);

    // Add the attendance record to the lecture document
    await lectureRef.collection('attendances').add(attendance.toJson());
    print('Attendance added successfully!');
  } catch (e) {
    print('Error adding attendance: $e');
  }
}
}
