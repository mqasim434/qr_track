// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isNumber = false,
    this.isPassword = false,
  });

  final String? label;
  final bool isPassword;
  final bool isNumber;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          label: Text(label.toString()),
          hintText: 'Enter $label',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : null,
        ),
        obscureText: isPassword,
      ),
    );
  }
}