import 'package:flutter/material.dart';
import 'package:hydrosensenew/AboutUs.dart';
import 'package:hydrosensenew/HelpCenter.dart';
import 'package:hydrosensenew/LiveMeterScreen.dart';
import 'package:hydrosensenew/Historyscreen.dart';
import 'package:hydrosensenew/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Analysisscreen extends StatefulWidget {
  const Analysisscreen({super.key});

  @override
  State<Analysisscreen> createState() => _AnalysisscreenState();
}

class _AnalysisscreenState extends State<Analysisscreen> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Analysis",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF091534),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              color: Colors.blue,
              size: 35,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 47, 41, 209),
                    Color.fromARGB(255, 6, 4, 75),
                  ],
                  begin: Alignment.topCenter, // start alignment
                  end: Alignment.bottomCenter, // end alignment
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40.0, // increased radius to accommodate the border
                    backgroundColor: Color.fromARGB(
                      255,
                      2,
                      62,
                      8,
                    ), // border color
                    child: CircleAvatar(
                      radius: 37.0,
                      backgroundImage: AssetImage('assets/Logo_drop 2.jpg'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'User',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.sensors), // For live sensor readings
              title: const Text('Live Readings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveMeterScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart), // For live graph view
              title: const Text('Live Graph'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Historyscreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined), // For analysis
              title: const Text('Analysis'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Analysisscreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline), // Help center icon
              title: const Text('Help Center'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpCenter()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline), // About Us info icon
              title: const Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUs()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs
                    .clear(); // Or use prefs.setBool('isLoggedIn', false);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignIn()),
                  (route) => false,
                );
              },
            ),

            SizedBox(height: 30),
            ListTile(
              title: Text(
                'Version 1.0\nCopyright 2025 HYDROSENSE. All rights reserved.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              onTap: null,
            ),
          ],
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            '🛠️ This feature is under development.\n\n🚀 Coming soon with the best UI design possible!',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        selectedItemColor: const Color.fromARGB(255, 12, 97, 166),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LiveMeterScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Historyscreen()),
            );
          }
        },
      ),
    );
  }
}
