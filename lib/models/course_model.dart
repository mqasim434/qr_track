import 'package:qr_track/models/user_model.dart';

class CourseModel {
  String? courseId;
  String? courseTitle;
  String? courseCode;
  String? creditHours;
  String? instructor;
  String? roomLabel;
  String? department;
  String? section;
  String? batch;
  String? program;
  List<StudentModel>? students;

  CourseModel(
      {this.courseId,
      this.courseTitle,
      this.courseCode,
      this.creditHours,
      this.instructor,
      this.roomLabel,
      this.department,
      this.section,
      this.batch,
      this.program,
      this.students});

  CourseModel.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    courseTitle = json['courseTitle'];
    courseCode = json['courseCode'];
    creditHours = json['creditHours'];
    instructor = json['instructor'];
    roomLabel = json['roomLabel'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['courseId'] = courseId;
    data['courseTitle'] = courseTitle;
    data['courseCode'] = courseCode;
    data['creditHours'] = creditHours;
    data['instructor'] = instructor;
    data['roomLabel'] = roomLabel;
    data['department'] = department;
    data['section'] = section;
    data['batch'] = batch;
    data['program'] = program;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
