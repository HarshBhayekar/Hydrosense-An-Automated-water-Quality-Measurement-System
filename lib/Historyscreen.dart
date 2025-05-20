import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hydrosensenew/AboutUs.dart';
import 'package:hydrosensenew/Analysisscreen.dart';
import 'package:hydrosensenew/HelpCenter.dart';
import 'package:hydrosensenew/LiveMeterScreen.dart';
import 'package:hydrosensenew/SignIn.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For date formatting

class Historyscreen extends StatefulWidget {
  const Historyscreen({super.key});

  @override
  State<Historyscreen> createState() => _HistoryscreenState();
}

class _HistoryscreenState extends State<Historyscreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  List<String> timestamps = [];
  Map<String, Map<String, double>> readingMap = {}; // key = timestamp

  int _selectedIndex = 2;
  final List<String> fields = ['Turbidity', 'EC', 'TDS','Temperature', 'PH'];

  @override
  void initState() {
    super.initState();
    _fetchLiveData();
  }

  void _fetchLiveData() {
    final today = DateFormat('d-M-yyyy').format(DateTime.now());
    // final today = "20-4-2025";

    _dbRef.child("Vaibhav_Home").child(today).onValue.listen((
      DatabaseEvent event,
    ) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final Map<String, Map<String, double>> tempMap = {};

        List<String> timeList = data.keys.cast<String>().toList();
        timeList.sort((a, b) => b.compareTo(a)); // latest first

        for (String time in timeList) {
          final raw = Map<String, dynamic>.from(data[time]);

          final Map<String, double> cleanEntry = {};
          for (var field in fields) {
            final val = raw[field];
            cleanEntry[field] = val is num ? val.toDouble() : 0.0;
          }

          tempMap[time] = cleanEntry;
        }

        setState(() {
          readingMap = tempMap;
          timestamps = timeList;
        });
      } else {
        setState(() {
          readingMap = {};
          timestamps = [];
        });
      }
    });
  }

  List<FlSpot> _generateSpots(String field) {
    return List.generate(timestamps.length, (index) {
      final data = readingMap[timestamps[index]]!;
      return FlSpot(index.toDouble(), data[field] ?? 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> chartColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Live Graph",
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
          readingMap.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: timestamps.length * 40, // Adjust width dynamically
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 500, // Set min Y for better view
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index >= 0 && index < timestamps.length) {
                                  List<String> parts = timestamps[index].split(
                                    ':',
                                  );
                                  String formattedTime =
                                      parts.length >= 5
                                          ? '${parts[3]}:${parts[4]}'
                                          : timestamps[index];
                                  return Transform.rotate(
                                    angle: -0.7,
                                    child: Text(
                                      formattedTime,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 50, // ✅ Reduces clutter on Y-axis
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toStringAsFixed(0),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        lineBarsData: List.generate(fields.length, (i) {
                          return LineChartBarData(
                            spots: _generateSpots(fields[i]),
                            isCurved: true,
                            color: chartColors[i],
                            barWidth: 2,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  chartColors[i].withOpacity(0.4),
                                  chartColors[i].withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          );
                        }),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.black87,
                            fitInsideHorizontally:
                                true, // ✅ Prevents tooltip from overflowing horizontally
                            fitInsideVertically:
                                true, // ✅ Prevents tooltip from overflowing vertically
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((spot) {
                                final fieldIndex = touchedSpots.indexOf(spot);
                                final fieldName = fields[fieldIndex];
                                return LineTooltipItem(
                                  '$fieldName: ${spot.y.toStringAsFixed(2)}',
                                  TextStyle(
                                    color: chartColors[fieldIndex],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
}
