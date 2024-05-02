#define FLOW_SENSOR_PIN 9 // Pin number connected to the output of the flow sensor
#include "WiFiProv.h"
#include "WiFi.h"
#include "nvs_flash.h"
#include "nvs.h"
#include <PubSubClient.h>
#include <WiFi.h>

const char* ssid = "mitch laptop";
const char* password = "lol123456";
const char* mqttServer = "192.168.137.13";
const int mqttPort = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

float cumSum = 0;
float numSec = 0;
volatile int flow_count = 0; // Variable to store the flow count
unsigned long startTime = 0; // Variable to store the start time of flow
unsigned long endTime = 0; // Variable to store the end time of flow

void IRAM_ATTR pulseCounter() {
  flow_count++; // Increment the flow count when a pulse is detected
}

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi..");
    }

    Serial.println("Connected to WiFi");

    client.setServer(mqttServer, mqttPort);
    
    while (!client.connected()) {
        Serial.print("Attempting MQTT connection to ");
        Serial.print(mqttServer);
        Serial.print("...");
        if (client.connect("XIAOClient")) {
            Serial.println("connected");
        } else {
            Serial.print("failed, rc=");
            Serial.print(client.state());
            Serial.println(" try again in 5 seconds");
            delay(5000);
        }
    }
  pinMode(FLOW_SENSOR_PIN, INPUT_PULLUP); // Set the flow sensor pin as input with internal pull-up resistor
  attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN), pulseCounter, RISING); // Attach interrupt to the flow sensor pin
}

void loop() {
    delay(1000); // Wait for 1 second

    detachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN)); // Detach interrupt to prevent race condition
    float flowRate = (flow_count / 7.5); // Calculate flow rate (assuming 7.5 pulses per liter)
    flow_count = 0; // Reset flow count
    attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN), pulseCounter, RISING); // Reattach interrupt

    //Serial.print(F("Flow Rate: "));
    //Serial.print(flowRate);
    //Serial.println(F(" L/min"));

    // Check if flow is active
    if (flowRate > 0) {
      // If flow has just started, record the start time
      numSec++;
      if (startTime == 0) {
        startTime = millis();
      }

      cumSum += (flowRate / 60);

    } else {
      // If flow has stopped and we have recorded a start time, calculate total volume and reset start time
      if (startTime != 0) {
        endTime = millis();
        
        unsigned long duration = (endTime - startTime) / 1000;
        Serial.print(F("Total Volume: "));
        Serial.println(cumSum - .18);
        Serial.println(duration);

        char buffer[50];

        sprintf(buffer, "%.2f\n%d\n", cumSum-.18, duration);

        client.publish("flow", buffer);

        startTime = 0; // Reset start time
        endTime = 0; // Reset end time
        cumSum = 0;
        numSec = 0;
      }
    }
}
