#define FLOW_SENSOR_PIN 10 // Pin number connected to the output of the flow sensor

volatile int flow_count = 0; // Variable to store the flow count

void IRAM_ATTR pulseCounter() {
  flow_count++; // Increment the flow count when a pulse is detected
}

void setup() {
  Serial.begin(9600); // Initialize serial communication
  pinMode(FLOW_SENSOR_PIN, INPUT_PULLUP); // Set the flow sensor pin as input with internal pull-up resistor
  attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN), pulseCounter, RISING); // Attach interrupt to the flow sensor pin
}

void loop() {
  delay(1000); // Wait for 1 second

  detachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN)); // Detach interrupt to prevent race condition
  int flowRate = (flow_count * 60/ 7.5); // Calculate flow rate (assuming 7.5 pulses per liter)
  flow_count = 0; // Reset flow count
  attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN), pulseCounter, RISING); // Reattach interrupt
  
  Serial.print("Flow Rate: ");
  Serial.print(flowRate);
  Serial.println(" L/min");
}
