🌊 HydroSense: An Automated Water Quality Monitoring System

HydroSense is a smart, real-time water quality monitoring system designed using the Flutter framework, Firebase, and Arduino UNO R4 WiFi. It enables accurate and continuous measurement of key water parameters like TDS, pH, Turbidity, Temperature, and derived Electrical Conductivity (EC). This solution bridges the gap between water quality monitoring and accessibility—especially in rural and resource-constrained regions.
📱 Mobile App Features

    🔐 Authentication Module: Login, Sign Up, and Forgot Password functionality.

    📊 Dashboard: Real-time readings for TDS, pH, Turbidity, and Temperature.

    📈 Graphical Analytics: Historical data visualization and trend analysis.

    🔔 Real-Time Alerts: Notifications for unsafe water conditions.

    🌐 IoT Integration: Fetches live data from sensors via Firebase.

🔧 Hardware Components
Component	Description
Arduino UNO R4 WiFi	Central controller with built-in ESP32 WiFi
TDS Sensor	Measures Total Dissolved Solids & EC
pH Sensor	Monitors acidity/alkalinity of water
Turbidity Sensor	Detects clarity based on suspended particles
Temperature Sensor	Measures real-time water temperature
Buzzer	Triggers alerts when thresholds are crossed
Power Supply	5V DC adapter or 12V barrel jack

🧠 Software Technologies

   Frontend: Flutter + Dart

   Backend: Firebase Realtime Database

   Programming (Microcontroller): Arduino C/C++

   Libraries:

        Gravity TDS

        OneWire & DallasTemperature

        Firebase Arduino SDK

        NTPClient (for date/time)

🧪 Key Functionalities

    Continuous monitoring of TDS, pH, Turbidity, Temperature.

    Cloud sync with Firebase for data logging.

    Offline storage and re-sync when connectivity returns.

    Buzzer alerts for thresholds breach.

    Intuitive mobile interface for users to monitor data.

    Can be used in homes, industries, government tanks, and agriculture.

🗂 Modules
🔌 Hardware Modules

    Sensor Array (TDS, pH, Turbidity, Temp)

    WiFi transmission (ESP32)

    Indicator module (Buzzer + LEDs)

🖥 Software Modules

    Splash Screen

    Auth System (Login/Register)

    Real-Time Monitoring

    Historical Data Graphing

    Firebase Data Management

📦 Installation & Setup
🔋 Hardware Setup

    Connect sensors to Arduino UNO R4 WiFi as per pin configuration.

    Upload HydroSense.ino using Arduino IDE.

    Configure WiFi credentials and Firebase URL in arduino_secrets.h.

📲 Mobile App

    Clone this repo.

    Open in VS Code or Android Studio.

    Run using:

    flutter pub get
    flutter run

    Ensure internet access and Firebase setup.

🔒 Security

    Password authentication implemented for secure access.

    Firebase database rules can be configured to restrict unauthorized writes.

👥 Team Members

    Vaibhav Gangadhar Jawadwar

    Harsh Shamsundar Bhayekar

    Yashsinh Hanumansinh Thakur

📝 Future Improvements

    Integration of AI/ML for predictive water contamination analysis.

    SMS-based alerts for non-smartphone users.

    Solar-powered version for energy efficiency.

    Integration with government water safety dashboards.

📃 License

© 2025 All Rights Reserved | Harsh Bhayekar


code for aurdino : 
file provided in main branch
