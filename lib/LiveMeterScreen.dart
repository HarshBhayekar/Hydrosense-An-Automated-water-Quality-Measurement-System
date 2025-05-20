import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hydrosensenew/AboutUs.dart';
import 'package:hydrosensenew/Analysisscreen.dart';
import 'package:hydrosensenew/HelpCenter.dart';
import 'package:hydrosensenew/Historyscreen.dart';
import 'package:hydrosensenew/SignIn.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LiveMeterScreen extends StatefulWidget {
  const LiveMeterScreen({super.key});

  @override
  State<LiveMeterScreen> createState() => _LiveMeterScreenState();
}

class _LiveMeterScreenState extends State<LiveMeterScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int _selectedIndex = 0;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child(
    "Vaibhav_Home",
  );

  Map<String, dynamic>? latestData;
  String? latestTime;

  @override
  void initState() {
    super.initState();
    _initializeNotifications(); // ✅ Init Notification
    _listenToLiveData();
  }
  // old function ---------------------------------------------------------------------------
  // void _listenToLiveData() {
  //   // for specific time reading for testing purpose only
  //   final specificDate = "15-4-2025";

  //   // //for live readings for production purpose only
  //   // final specificDate = DateFormat('d-M-yyyy').format(DateTime.now());  //for live readings

  //   _dbRef.child(specificDate).onValue.listen((DatabaseEvent event) {
  //     final data = event.snapshot.value as Map?;
  //     if (data != null) {
  //       List<String> timestamps = data.keys.cast<String>().toList();
  //       timestamps.sort((a, b) => a.compareTo(b)); // latest first
  //       final latest = timestamps.first;
  //       final latestEntry = Map<String, dynamic>.from(data[latest]);

  //       setState(() {
  //         latestData = latestEntry;
  //         latestTime = latest;
  //       });
  //     } else {
  //       setState(() {
  //         latestData = null;
  //         latestTime = null;
  //       });
  //     }
  //   });
  // }

  // ✅ 1. Initialize Notification Plugin
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // ✅ 2. Show notification
  int _notificationId = 0; // Global or class-level

Future<void> _showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'sensor_alerts', // channel ID
        'Sensor Alerts', // channel name
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  // ✅ Cycle through IDs 0–4 to keep max 5 notifications
  await flutterLocalNotificationsPlugin.show(
    _notificationId,
    title,
    body,
    platformChannelSpecifics,
  );

  _notificationId = (_notificationId + 1) % 5;
}


  // old function latest1 ---------------------------------------------------------------------------

  //   void _listenToLiveData() {
  // // for specific time reading for testing purpose only
  //     // final specificDate = "15-4-2025";

  //   final specificDate = DateFormat('d-M-yyyy').format(DateTime.now());

  //   _dbRef.child(specificDate).onValue.listen((DatabaseEvent event) {
  //     final data = event.snapshot.value as Map?;
  //     if (data != null) {
  //       List<String> timestamps = data.keys.cast<String>().toList();
  //       timestamps.sort((a, b) => b.compareTo(a)); // latest first
  //       final latest = timestamps.first;
  //       final latestEntry = Map<String, dynamic>.from(data[latest]);

  //       // Merge with previous data if null fields are found
  //       final mergedEntry = <String, dynamic>{};
  //       final fields = ['TDS', 'Temperature', 'PH', 'Turbidity', 'EC'];

  //       for (final key in fields) {
  //         mergedEntry[key] = latestEntry[key] ?? latestData?[key] ?? 0.0;
  //       }

  //       setState(() {
  //         latestData = mergedEntry;
  //         latestTime = latest;
  //       });
  //     } else {
  //       // If the date has no data at all
  //       setState(() {
  //         latestData = latestData; // keep old
  //         latestTime = latestTime;
  //       });
  //     }
  //   });
  // }

  // ✅ 3. Main Live Data Listening with Notification
  void _listenToLiveData() {
    // for specific time reading for testing purpose only
    // final specificDate = "20-4-2025";

    final specificDate = DateFormat('d-M-yyyy').format(DateTime.now());

    _dbRef.child(specificDate).onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        List<String> timestamps = data.keys.cast<String>().toList();
        timestamps.sort((a, b) => b.compareTo(a));
        final latest = timestamps.first;
        final latestEntry = Map<String, dynamic>.from(data[latest]);

        final mergedEntry = <String, dynamic>{};
        final fields = ['TDS', 'Temperature', 'PH', 'Turbidity', 'EC'];

        for (final key in fields) {
          mergedEntry[key] = latestEntry[key] ?? latestData?[key] ?? 0.0;
        }

        setState(() {
          latestData = mergedEntry;
          latestTime = latest;
        });

        // ✅ 4. Add Limit Check and Notification
        final double tds =
            double.tryParse(mergedEntry['TDS'].toString()) ?? 0.0;
        final double temp =
            double.tryParse(mergedEntry['Temperature'].toString()) ?? 0.0;
        final double ph = double.tryParse(mergedEntry['PH'].toString()) ?? 0.0;
        final double turbidity =
            double.tryParse(mergedEntry['Turbidity'].toString()) ?? 0.0;
        final double ec = double.tryParse(mergedEntry['EC'].toString()) ?? 0.0;

        if (tds > 300) {
          _showNotification(
            "High TDS Alert",
            "TDS is above safe limit: $tds PPM",
          );
        }
        if (temp > 60) {
          _showNotification(
            "Temperature Alert",
            "Temperature is high: $temp °C",
          );
        }
        if (ph < 5.5 || ph > 9.5) {
          _showNotification("pH Alert", "pH level out of range: $ph");
        }
        if (turbidity > 180) {
          _showNotification(
            "Turbidity Alert",
            "Turbidity is high: $turbidity NTU",
          );
        }
        
      } else {
        setState(() {
          latestData = latestData;
          latestTime = latestTime;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Live Readings",
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
      body:
          latestData == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  if (latestTime != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                        left: 0,
                        right: 16,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "🕒 TimeStamp: $latestTime",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  buildGaugeCard(
                    "TDS",
                    double.tryParse(latestData!['TDS'].toString()) ?? 0.0,
                    "PPM",
                    0,
                    1000,
                  ),
                  buildGaugeCard(
                    "Temperature",
                    double.tryParse(latestData!['Temperature'].toString()) ??
                        0.0,
                    "°C",
                    0,
                    100,
                  ),
                  buildGaugeCard(
                    "EC",
                    double.tryParse(latestData!['EC'].toString()) ?? 0.0,
                    "µS/cm",
                    0,
                    200,
                  ),
                  buildGaugeCard(
                    "PH",
                    double.tryParse(latestData!['PH'].toString()) ?? 0.0,
                    "pH",
                    0,
                    14,
                  ),
                  buildGaugeCard(
                    "Turbidity",
                    double.tryParse(latestData!['Turbidity'].toString()) ?? 0.0,
                    "NTU",
                    0,
                    500,
                  ),
                ],
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // 👈 Tells which item is selected
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
            _selectedIndex = index; // 👈 Update selected index
          });

          // Navigation logic
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Analysisscreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Historyscreen()),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LiveMeterScreen()),
            );
          }
        },
      ),
    );
  }

  Widget buildGaugeCard(
    String title,
    double value,
    String unit,
    double min,
    double max,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 34),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 46),
        width: double.infinity,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 220,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: min,
                    maximum: max,
                    showLabels: true,
                    showTicks: true,
                    axisLineStyle: const AxisLineStyle(
                      thickness: 0.20,
                      cornerStyle: CornerStyle.bothFlat,
                      color: Color.fromARGB(40, 1, 76, 10),
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    pointers: <GaugePointer>[
                      RangePointer(
                        value: value,
                        width: 0.20,
                        color: const Color.fromARGB(255, 5, 136, 29),
                        cornerStyle: CornerStyle.endCurve,
                        sizeUnit: GaugeSizeUnit.factor,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              value.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              unit,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 84, 83, 83),
                              ),
                            ),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 1.2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
