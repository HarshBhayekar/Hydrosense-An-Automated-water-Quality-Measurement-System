import 'package:flutter/material.dart';
import 'package:hydrosensenew/AboutUs.dart';
import 'package:hydrosensenew/Analysisscreen.dart';
import 'package:hydrosensenew/HelpCenter.dart';
import 'package:hydrosensenew/LiveMeterScreen.dart';
import 'package:hydrosensenew/OnBoarding1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(const Duration(seconds: 3)); // Splash duration

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LiveMeterScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Onboarding()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/SplashscreenArtboard3.png",
              fit: BoxFit.cover,
            ),
          ),
          // Loading Spinner
          const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF0E2D61),
            ),
          ),
        ],
      ),
    );
  }
}
