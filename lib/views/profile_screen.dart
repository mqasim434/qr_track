// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_track/models/user_model.dart';
import 'package:qr_track/res/colors.dart';
import 'package:qr_track/res/enums.dart';
import 'package:qr_track/res/utility_functions.dart';
import 'package:qr_track/services/theme_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> updateUserField(String field, String data) async {
    try {
      EasyLoading.show(status: 'Updating Field');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(UtilityFunctions.getCollectionName(
                  UserModel.currentUser.userType))
              .where('email', isEqualTo: UserModel.currentUser.email)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        DocumentReference<Map<String, dynamic>> documentReference =
            documentSnapshot.reference;

        if (UserModel.currentUser.userType == UserRoles.Teacher.name) {
          TeacherModel teacherModel =
              TeacherModel.fromJson(documentSnapshot.data()!);
          teacherModel.updateField(field, data);
          await documentReference.update(teacherModel.toJson());
        } else {
          StudentModel studentModel =
              StudentModel.fromJson(documentSnapshot.data()!);
          studentModel.updateField(field, data);
          await documentReference.update(studentModel.toJson());
        }
        await getUserData();
      } else {
        print('No user found with the specified email.');
      }
    } catch (e) {
      print(e);
    }
    EasyLoading.dismiss();
  }

  Future<void> getUserData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(UtilityFunctions.getCollectionName(
                  UserModel.currentUser.userType))
              .where('email', isEqualTo: UserModel.currentUser.email)
              .limit(1)
              .get();

      if (UserModel.currentUser.userType == UserRoles.Teacher) {
        UserModel.currentUser =
            TeacherModel.fromJson(querySnapshot.docs.first.data());
      } else {
        UserModel.currentUser =
            StudentModel.fromJson(querySnapshot.docs.first.data());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImageToFirebase(File imageFile) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    print(imageFile.path.split('/').last);
    try {
      final uploadTask = firebaseStorage
          .ref()
          .child('images/${imageFile.path.split('/').last}')
          .putFile(imageFile);

      final taskSnapshot = await uploadTask.whenComplete(() => {});

      final downloadURL = await taskSnapshot.ref.getDownloadURL();
      await updateUserField('imageUrl', downloadURL);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> pickImage(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(source: imageSource);
    if (pickedImage != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Image Preview'),
            content: SizedBox(
              height: 300,
              child: Image.file(
                File(pickedImage.path),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  uploadImageToFirebase(File(pickedImage.path));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: Size(
                    double.maxFinite,
                    50,
                  ),
                ),
                child: Text(
                  'Select',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );
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
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            UserModel.currentUser.profileImage != null
                ? Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            NetworkImage(UserModel.currentUser.profileImage),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10),
                        child: CircleAvatar(
                          backgroundColor: AppColors.primaryColor,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        child: Icon(Icons.person),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10),
                        child: InkWell(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Choose an option'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          pickImage(ImageSource.camera),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.camera,
                                        ),
                                        title: Text('Camera'),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () =>
                                          pickImage(ImageSource.gallery),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.browse_gallery,
                                        ),
                                        title: Text('Gallery'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ],
                  ),
            SizedBox(
              height: 12,
            ),
            Text(
              UserModel.currentUser.fullName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              UserModel.currentUser.userType,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: screenWidth,
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Provider.of<ThemeService>(context).currentThemeMode ==
                          'Light Theme'
                      ? Colors.white
                      : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'General Info',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InfoTile(
                    text: UserModel.currentUser.fullName,
                    icon: Icons.person_2_outlined,
                    onTap: () {
                      showUpdateFieldDialogue(
                          context, 'fullName', UserModel.currentUser.fullName);
                    },
                  ),
                  Divider(),
                  InfoTile(
                    text: UserModel.currentUser.email,
                    icon: Icons.email_outlined,
                    onTap: () {},
                  ),
                  Divider(),
                  InfoTile(
                    text: UserModel.currentUser.phone ?? 'null',
                    icon: Icons.phone_android_outlined,
                    onTap: () {
                      showUpdateFieldDialogue(context, 'phone',
                          UserModel.currentUser.phone ?? "Enter Phone Number");
                    },
                  ),
                  Divider(),
                  UserModel.currentUser.userType == UserRoles.Teacher.name
                      ? InfoTile(
                          text: UserModel.currentUser.teacherId,
                          icon: Icons.person_4_outlined,
                          onTap: () {},
                        )
                      : InfoTile(
                          text: UserModel.currentUser.rollNo,
                          icon: Icons.person_4_outlined,
                          onTap: () {},
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<dynamic> showUpdateFieldDialogue(
      BuildContext context, String field, String original) {
    return showDialog(
        context: context,
        builder: (context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: Text('Update User Field'),
            content: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: original,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  updateUserField(field, controller.text).then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Text('Update'),
              ),
            ],
          );
        });
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String? text;
  final IconData? icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 28,
            ),
            SizedBox(
              width: 12,
            ),
            Text(
              text.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
        (icon != Icons.email_outlined && icon != Icons.person_4_outlined)
            ? InkWell(onTap: () => onTap(), child: Icon(Icons.edit))
            : SizedBox(),
      ],
    );
  }
}
