import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final List<Map<String, String>> developers = [
    {
      'name': 'Vaibhav Jawadwar',
      'role': 'Hardware Designer',
      'email': 'vaibhavjawadwar5@gmail.com',
      'phone': '+91 7083586756',
    },
    {
      'name': 'Harsh Bhayekar',
      'role': 'Flutter Developer',
      'email': 'hsbhayekar2004@gmail.com',
      'phone': '+91 7276523721',
    },
    {
      'name': 'Yash Thakur',
      'role': 'Firebase & Backend',
      'email': 'yashthakur192203@gmail.com',
      'phone': '+91 7385404060',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFF091534),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "About Us",
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Description',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Color(0xFF091534),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This project focuses on real-time monitoring and analysis of water quality using modern technologies.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This project is developed with the aim of improving water quality monitoring and ensuring safe drinking water for communities. ',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• Real-time water quality analysis using sensors."),
                  Text("• Firebase integration for live data storage."),
                  Text("• User-friendly interface built using Flutter."),
                  Text("• TDS, PH, EC, and Turbidity monitoring."),
                  Text("• Historical data visualization and analysis."),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Developers',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Color(0xFF091534),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  developers.map((dev) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: Card(
                        color: const Color.fromARGB(255, 231, 231, 232), // Dark Blue Background
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dev['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dev['role']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(179, 0, 0, 0),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.email,
                                    color: Color.fromARGB(179, 3, 4, 98),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      dev['email']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    color: Color.fromARGB(255, 33, 184, 49),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      dev['phone']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
