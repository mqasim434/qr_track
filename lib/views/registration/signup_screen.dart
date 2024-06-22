// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:qr_track/res/colors.dart';
import 'package:qr_track/res/components/my_textfield.dart';
import 'package:qr_track/res/components/role_widget.dart';
import 'package:qr_track/res/components/rounded_rectangular_button.dart';
import 'package:qr_track/res/enums.dart';
import 'package:qr_track/views/registration/signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  UserRoles selectedRole = UserRoles.Teacher;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController teacherIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * 0.4,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(150),
                    bottomRight: Radius.circular(150),
                  ),
                ),
              )
            ],
          ),
          SingleChildScrollView(
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black26,
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Continue using:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RoleWidget(
                          role: UserRoles.Teacher.name,
                          icon: Icons.person,
                          isSelected: selectedRole == UserRoles.Teacher,
                          onTap: () {
                            setState(() {
                              selectedRole = UserRoles.Teacher;
                            });
                          },
                        ),
                        RoleWidget(
                          role: UserRoles.Student.name,
                          icon: Icons.person,
                          isSelected: selectedRole == UserRoles.Student,
                          onTap: () {
                            setState(() {
                              selectedRole = UserRoles.Student;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                      label: 'Name',
                      controller: nameController,
                    ),
                    MyTextField(
                      label: 'Email',
                      controller: emailController,
                    ),
                    selectedRole == UserRoles.Student
                        ? MyTextField(
                            label: 'Roll No',
                            controller: rollNoController,
                          )
                        : MyTextField(
                            label: 'Teacher Id',
                            controller: teacherIdController,
                          ),
                    MyTextField(
                      label: 'Password',
                      controller: passwordController,
                    ),
                    MyTextField(
                      label: 'Confirm Password',
                      controller: confirmPasswordController,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    RoundedRectangularButton(
                      label: 'Sign up',
                      onPress: () {},
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SigninScreen(),
                              ),
                            );
                          },
                          child: Text('Sign in'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
