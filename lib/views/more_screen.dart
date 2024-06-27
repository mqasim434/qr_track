// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_track/res/colors.dart';
import 'package:qr_track/services/registration_services.dart';
import 'package:qr_track/services/theme_service.dart';
import 'package:qr_track/views/about_screen.dart';
import 'package:qr_track/views/profile_screen.dart';
import 'package:qr_track/views/registration/signin_screen.dart';

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
                      onPress: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProfileScreen();
                        }));
                      },
                    ),
                    ThemeToffeeWidget()
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ToffeeWidget(
                      label: "Change Password",
                      iconData: Icons.person,
                      onPress: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProfileScreen();
                        }));
                      },
                    ),
                    ToffeeWidget(
                      label: "About",
                      iconData: Icons.info,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      MediaQuery.of(context).size.width,
                      50,
                    ),
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    RegistrationServices.logoutUser().then((value) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => SigninScreen()),
                        (Route<dynamic> route) => false,
                      );
                    });
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
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
          color: Provider.of<ThemeService>(context).currentThemeMode ==
                  'Light Theme'
              ? AppColors.secondaryColor
              : AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 80,
                color: Provider.of<ThemeService>(context).currentThemeMode ==
                        'Light Theme'
                    ? Colors.white
                    : Colors.white70,
              ),
              Text(
                label.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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

class ThemeToffeeWidget extends StatelessWidget {
  const ThemeToffeeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Provider.of<ThemeService>(context, listen: false).toggleTheme();
      },
      child: Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.2,
        decoration: BoxDecoration(
          color: Provider.of<ThemeService>(context).currentThemeMode ==
                  'Light Theme'
              ? AppColors.secondaryColor
              : AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Provider.of<ThemeService>(context).currentThemeMode ==
                        'Light Theme'
                    ? Icons.light_mode
                    : Icons.dark_mode,
                size: 80,
                color: Provider.of<ThemeService>(context).currentThemeMode ==
                        'Light Theme'
                    ? Colors.white
                    : Colors.white70,
              ),
              Text(
                Provider.of<ThemeService>(context).currentThemeMode.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Provider.of<ThemeService>(context).currentThemeMode ==
                          'Light Theme'
                      ? Colors.white
                      : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
