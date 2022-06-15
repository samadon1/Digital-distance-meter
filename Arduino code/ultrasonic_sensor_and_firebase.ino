#include <WiFi.h>
#include "FirebaseESP32.h"

#define FIREBASE_HOST "esp32-unity-project-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "mnk6cIN5m8ovTgXOhGn5ldcIJWlzXYgTvtFWXN5j"
#define WIFI_SSID "H"
#define WIFI_PASSWORD "12345678"

FirebaseData firebaseData;
// defines pins numbers
const int trigPin = 2;
const int echoPin = 5;
// defines variables
long duration;
int distance;
void setup() {
pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
pinMode(echoPin, INPUT); // Sets the echoPin as an Input
Serial.begin(9600); // Starts the serial communication

WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
Firebase.reconnectWiFi(true);


Firebase.setReadTimeout(firebaseData, 1000 * 60);
Firebase.setwriteSizeLimit(firebaseData, "tiny");
}


void loop() {
// Clears the trigPin
digitalWrite(trigPin, LOW);
delayMicroseconds(2);
// Sets the trigPin on HIGH state for 10 micro seconds
digitalWrite(trigPin, HIGH);
delayMicroseconds(10);
digitalWrite(trigPin, LOW);
// Reads the echoPin, returns the sound wave travel time in microseconds
duration = pulseIn(echoPin, HIGH);
// Calculating the distance
distance= duration*0.034/2;
// Prints the distance on the Serial Monitor
Serial.print("Distance: ");
Serial.println(distance);

//Firebase.pushInt("distance", distance);
//Firebase.setInt(distance)
//Firebase.setString("test/string", "89")
Firebase.setString(firebaseData, F("/test/string"), distance);
}
