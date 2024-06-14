# HydroConnect

This repo contains all the code used for the HydroConnect water sensing system. We have organized the repo with the following file structure and important files:

<pre>
Root
|
+-- flow_sensor - MQTT Broker and MCU
|   |
|   +-- broker.py   - MQTT Broker
|   +-- flow_sensor.ino - MCU Code
|
+-- water_tap_app - Mobile App with XCode
|   |
|   +-- water_tap_app - Swift Source Code
|   |
|   +-- backend - Server Communications Source Code
|   |   |
|   |   +-- http_handling.swift - HTTP services
|   |   +-- QRScannerView.swift - QR Scanner services
|   |
|   +-- frontend - Frontend and UI Source Code  
|   |   |
|   |   +-- ContentView.swift - SwiftUI preview file
|   |   +-- HomeFrontend.swift - Homepage
|   |   +-- LoginFrontend.swift - Login Page
|   |   +-- SensorDataView.swift - Data tiles
|   |   +-- SignUpView.swift - Signup page
|   |   
|   +-- water_tap_app.xcodeproj - XCode IDE Files
|   +-- water_tap_appTests - Unit Tests
|   +-- water_tap_appUITests - UI Unit Tests
+-- web_server - Webserver and Database
|   |
|   +-- app.py - Webserver
|   +-- db.py  - Database
|   +-- keygen.py - Key Generator
+-- README.md
</pre>