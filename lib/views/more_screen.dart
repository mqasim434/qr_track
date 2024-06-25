// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:qr_track/res/colors.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'More',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ToffeeWidget(
                      label: "Profile",
                      iconData: Icons.person,
                      onPress: () {},
                    ),
                    ToffeeWidget(
                      label: "Profile",
                      iconData: Icons.person,
                      onPress: () {},
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class ToffeeWidget extends StatelessWidget {
  const ToffeeWidget({
    super.key,
    required this.label,
    required this.iconData,
    required this.onPress,
  });

  final String? label;
  final IconData? iconData;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => onPress(),
      child: Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.2,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 80,
                color: Colors.white,
              ),
              Text(
                label.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
