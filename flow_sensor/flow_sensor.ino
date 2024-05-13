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
int count = 0;
float saved;
int wifi_led = D5;
int power_led = D7;

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
  pinMode(power_led, OUTPUT);
  digitalWrite(power_led, HIGH);
  WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi..");
    }

    pinMode(wifi_led, OUTPUT);
    digitalWrite(wifi_led, HIGH);
    Serial.println("LED ON");
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

    Serial.print(F("Flow Rate: "));
    Serial.print(flowRate);
    Serial.println(F(" L/min"));

    // Check if flow is active
    if (flowRate > 0) {
      // If flow has just started, record the start time
      numSec++;
      if (startTime == 0) {
        startTime = millis();
      }

      if(count == 0) {
        saved = 0.18;
      } else if(flowRate >= 10) {
        Serial.print("Saved: ");
        Serial.println(saved);
        cumSum += (saved / 60);
      } else if(flowRate < 10) {
        cumSum += (flowRate / 60);
        saved = flowRate;
      } else {
        saved = 0.18;
      }

      count = count + 1;
    } else {
      // If flow has stopped and we have recorded a start time, calculate total volume and reset start time
      if (startTime != 0) {
        endTime = millis();
        
        unsigned long duration = (endTime - startTime) / 1000;
        Serial.print("Is connected to mqtt? ");
        Serial.println(client.connected());
        while(!client.connected()) {
          client.connect("XIAOClient");
        }
        if(client.connected()) {
          Serial.println("Connected!");
        }
        Serial.print(F("Total Volume: "));
        Serial.println(cumSum - .12);
        Serial.println(duration);

        char buffer[50];
        const char* sensor_id = "12345";
        const char* sink_id = "kitchen";

        sprintf(buffer, "%.2f\n%d\n%s\n%s\n", cumSum - .12, duration, sensor_id, sink_id);

        client.publish("flow", buffer);

        startTime = 0; // Reset start time
        endTime = 0; // Reset end time
        cumSum = 0;
        numSec = 0;
      }
    }
}
