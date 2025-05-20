import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrosensenew/Changepass.dart';

class OTP extends StatefulWidget {
  const OTP({super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final TextEditingController _otpController = TextEditingController();
  String _generatedOTP = "";

  // Function to generate a random 6-digit OTP
  void _generateOTP() {
    final random = Random();
    setState(() {
      _generatedOTP = (100000 + random.nextInt(900000)).toString();
    });
    print("Generated OTP: $_generatedOTP"); // Debugging: Print OTP in console
    Fluttertoast.showToast(msg: "OTP Sent: $_generatedOTP"); // [Simulating OTP sent to GMAIL in future]
  }

  // Function to verify OTP
  void _verifyOTP() {
    if (_otpController.text == _generatedOTP) {
      Fluttertoast.showToast(msg: "OTP Verified Successfully!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Changepass()),
      );
    } else {
      Fluttertoast.showToast(msg: "Invalid OTP.");
    }
  }

  @override
  void initState() {
    super.initState();
    _generateOTP(); // Generate OTP when page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/OPT.jpg",
              width: 300,
            ),
            const SizedBox(height: 20),
            const Text(
              "OTP Verification",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Enter OTP",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            const SizedBox(height: 7),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Color(0xFF7F7E7E)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Color(0xFF7F7E7E)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Color(0xFF4285F4), width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyOTP, // Call verify function
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF15047A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: _generateOTP, // Regenerate OTP
              child: const Text(
                "Resend OTP",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: Color(0xFF4285F4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
