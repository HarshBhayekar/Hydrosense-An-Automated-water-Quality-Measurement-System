import 'package:flutter/material.dart';
import 'package:hydrosensenew/OnboardingScreen2.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
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
              "assets/onboardingone.png", // Update with your actual image
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.54,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height:10),
          // Logo (Removed extra spacing above it)
          Image.asset("assets/Logo_drop 2.png", height: 170), // Your logo asset

          // Reduce space between logo and text
          Transform.translate(
            offset: const Offset(0, -18), // Moves the text slightly upward
            child: Column(
              children: [
                Text(
                  "Welcome to",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Hydrosense",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Poppins",
                    color: Color(0xFF1AA8CF),
                  ),
                ),
              ],
            ),
          ),

const SizedBox(height: 0),
          // "Step 1 of 3" Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Adjusted padding
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const OnboardingScreen2()),
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
                "Step 1 of 3",
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
