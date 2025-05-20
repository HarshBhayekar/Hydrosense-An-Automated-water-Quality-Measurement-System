import 'package:flutter/material.dart';
import 'package:hydrosensenew/OnboardingScreen3.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top Image with Rounded Corners
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(67),
              bottomRight: Radius.circular(67),
            ),
            child: Image.asset(
              "assets/onboardingtwo.jpg", // Update with your actual image
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.54,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 50),

          // Description Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Monitor and improve your water quality with precision. HydroSense helps you track purity levels, hydration habits, and more for a healthier lifestyle.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                fontFamily: "Poppins",
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 90),

          // "Step 2 of 3" Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Onboardingscreen3()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E2D61),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Step 2 of 3",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
