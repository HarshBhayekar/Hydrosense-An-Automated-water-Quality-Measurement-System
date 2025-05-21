// INCLUDES
#include <EEPROM.h>
#include "GravityTDS.h"
#include <OneWire.h>
#include <DallasTemperature.h>
#include <WiFiS3.h>
#include <NTPClient.h>
#include <WiFiUdp.h>
#include <ArduinoGraphics.h>
#include "Arduino_LED_Matrix.h"
#undef PORT
#include <Firebase.h>
#include <TimeLib.h>

// WIFI SSID AND PASSWORD AND FIREBASE API URL AND KEY
#include "arduino_secrets.h"

// FIREBASE CREDENTIALS
String FIREBASE_HOST = FIREBASE_HOST_URL;
String FIREBASE_AUTH = FIREBASE_AUTH_KEY;
Firebase fb(FIREBASE_HOST, FIREBASE_AUTH);

// DEFINE PIN CONSTANTS
#define ONE_WIRE_BUS 7
#define buzzer 13
#define PHSensorPin A4
#define TDSSensorPin A1
#define TurbiditySensorPin A3

// TDS BUZZER and TEMPERATURE SENSOR
OneWire oneWire(ONE_WIRE_BUS);
GravityTDS gravityTds;
DallasTemperature sensors(&oneWire);
float tdsValue = 0;
float ecValue = 0;
float Temperature = 0;

// PH SENSOR
#define Offset 0.00
#define samplingInterval 20
#define printInterval 800
#define ArrayLenth 40
int pHArray[ArrayLenth];
int pHArrayIndex = 0;

// TURBIDITY SENSOR
int read_ADC;
int ntu;

// WIFI and NTP and Date
char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;
int status = WL_IDLE_STATUS;

WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", 19800, 60000);
String Converted_Date = "";

// LED MATRIX
ArduinoLEDMatrix matrix;
const uint32_t happy[] = {
  0x19819,
  0x80000001,
  0x81f8000
};

// setup function
void setup(void) {
  Serial.begin(115200);
  sensors.begin();
  matrix.begin();

  matrix.beginDraw();
  matrix.textScrollSpeed(110);
  matrix.textFont(Font_5x7);
  matrix.beginText(0, 1, 0xFFFFFF);
  matrix.println("Welcome To HydroSense!!!");
  matrix.endText(SCROLL_LEFT);
  matrix.endDraw();
  matrix.clear();

  WiFi.disconnect();
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    while (true);
  }

  String fv = WiFi.firmwareVersion();
  if (fv < WIFI_FIRMWARE_LATEST_VERSION) {
    Serial.println("Please upgrade the firmware");
  }

  while (status != WL_CONNECTED) {
    matrix.loadSequence(LEDMATRIX_ANIMATION_WIFI_SEARCH);
    matrix.play();
    Serial.print("Attempting to connect to WPA SSID: ");
    Serial.println(ssid);
    status = WiFi.begin(ssid, pass);
    delay(10000);
  }

  Serial.println("You're connected to the network");
  timeClient.begin();

  gravityTds.setPin(TDSSensorPin);
  gravityTds.setAref(5.0);
  gravityTds.setAdcRange(1024);
  gravityTds.begin();
  pinMode(buzzer, OUTPUT);

  matrix.clear();
  matrix.loadFrame(happy);
  delay(6000);
  matrix.clear();
}

// loop function
void loop(void) {
  Serial.println();
  timeClient.update();
  Serial.print("Current time: ");
  Serial.println(timeClient.getFormattedTime());

  unsigned long epochTime = timeClient.getEpochTime();
  setTime(epochTime);
  int Day = day();
  int Month = month();
  int Year = year();
  Converted_Date = String(Day) + "-" + String(Month) + "-" + String(Year);
  Serial.print("Current Date: ");
  Serial.println(Converted_Date);

  sensors.requestTemperatures();
  gravityTds.setTemperature(sensors.getTempCByIndex(0));
  gravityTds.update();
  tdsValue = gravityTds.getTdsValue();
  ecValue = gravityTds.getEcValue();

  Serial.print("TDS Value: ");
  Serial.print(tdsValue, 2);
  Serial.println(" ppm");
  Serial.print("EC Value: ");
  Serial.print(ecValue, 2);
  Serial.println(" S/m");
  Temperature = sensors.getTempCByIndex(0);
  Serial.println("Temperature is: " + String(Temperature) + " .C");

  if (tdsValue > 300 || Temperature > 60) {
    digitalWrite(buzzer, HIGH);
    delay(500);
    digitalWrite(buzzer, LOW);
  }

  read_ADC = analogRead(TurbiditySensorPin);
  ntu = map(read_ADC, 0, 1023, 300, 0);
  Serial.print("Turbidity: ");
  Serial.print(ntu);
  Serial.print(" : ");
  if (ntu < 10) Serial.println("Water Very Clean");
  else if (ntu < 30) Serial.println("Water Norm Clean");
  else Serial.println("Water Very Dirty");

  static unsigned long samplingTime = millis();
  static unsigned long printTime = millis();
  static float pHValue, voltage;

  if (millis() - samplingTime > samplingInterval) {
    pHArray[pHArrayIndex++] = analogRead(PHSensorPin);
    if (pHArrayIndex == ArrayLenth) pHArrayIndex = 0;
    voltage = avergearray(pHArray, ArrayLenth) * 5.0 / 1024;
    pHValue = 1.65 * voltage + Offset;
    samplingTime = millis();
  }

  if (millis() - printTime > printInterval) {
    Serial.print("Voltage: ");
    Serial.print(voltage, 2);
    Serial.print(", PH value: ");
    Serial.println(pHValue, 2);
    printTime = millis();
  }

  SendInformation(Converted_Date, timeClient.getFormattedTime(), tdsValue, ecValue, Temperature, ntu, pHValue);
}

double avergearray(int* arr, int number) {
  int i, max, min;
  long amount = 0;
  double avg;

  if (number <= 0) return 0;

  if (number < 5) {
    for (i = 0; i < number; i++) amount += arr[i];
    return amount / number;
  } else {
    if (arr[0] < arr[1]) { min = arr[0]; max = arr[1]; }
    else { min = arr[1]; max = arr[0]; }

    for (i = 2; i < number; i++) {
      if (arr[i] < min) { amount += min; min = arr[i]; }
      else if (arr[i] > max) { amount += max; max = arr[i]; }
      else amount += arr[i];
    }
    avg = (double)amount / (number - 2);
  }
  return avg;
}

void SendInformation(String Converted_Date, String Time, float tdsValue, float ecValue, float Temperature, int ntu, float pHValue) {
  fb.setFloat("Vaibhav_Home/" + Converted_Date + "/" + Time + "/TDS", tdsValue);
  fb.setFloat("Vaibhav_Home/" + Converted_Date + "/" + Time + "/EC", ecValue);
  fb.setFloat("Vaibhav_Home/" + Converted_Date + "/" + Time + "/Temperature", Temperature);
  fb.setInt("Vaibhav_Home/" + Converted_Date + "/" + Time + "/Turbidity", ntu);
  fb.setFloat("Vaibhav_Home/" + Converted_Date + "/" + Time + "/PH", pHValue);
  Serial.println("Values Added Successfully!!!");
}
