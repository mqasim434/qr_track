import 'package:qr_track/models/course_model.dart';

class UserModel {
  String? fullName;
  String? email;
  String? profileImage;

  UserModel({this.fullName, this.email, this.profileImage});

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['email'] = email;
    data['profileImage'] = profileImage;
    return data;
  }

  static dynamic currentUser;
}

class StudentModel {
  String? rollNo;
  String? department;
  String? section;
  String? batch;
  String? program;
  List<CourseModel>? courses;

  StudentModel(
      {this.rollNo,
      this.department,
      this.section,
      this.batch,
      this.program,
      this.courses});

  StudentModel.fromJson(Map<String, dynamic> json) {
    rollNo = json['rollNo'];
    department = json['department'];
    section = json['section'];
    batch = json['batch'];
    program = json['program'];
    if (json['courses'] != null) {
      courses = <CourseModel>[];
      json['courses'].forEach((v) {
        courses!.add(CourseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rollNo'] = rollNo;
    data['department'] = department;
    data['section'] = section;
    data['batch'] = batch;
    data['program'] = program;
    if (courses != null) {
      data['courses'] = courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeacherModel {
  String? rollNo;
  String? department;
  String? section;
  String? batch;
  String? program;
  List<CourseModel>? courses;

  TeacherModel(
      {this.rollNo,
      this.department,
      this.section,
      this.batch,
      this.program,
      this.courses});

  TeacherModel.fromJson(Map<String, dynamic> json) {
    rollNo = json['rollNo'];
    department = json['department'];
    section = json['section'];
    batch = json['batch'];
    program = json['program'];
    if (json['courses'] != null) {
      courses = <CourseModel>[];
      json['courses'].forEach((v) {
        courses!.add(CourseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rollNo'] = rollNo;
    data['department'] = department;
    data['section'] = section;
    data['batch'] = batch;
    data['program'] = program;
    if (courses != null) {
      data['courses'] = courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
