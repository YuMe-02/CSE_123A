//
//  HomeFrontend.swift
//  water_tap_app
//
//  Created by Gary Mejia on 4/18/24.
//

import Foundation
import SwiftUI
import Charts

struct HomeView: View {
    @State private var serialID: String = ""
    @State private var sinkLocation: String = ""
    @State private var request_sink: String = ""
    @State private var errorMessage: String?
    @State private var responseMessage: String?
    @State private var showAlert = false
    @State private var navigateToSensorDataView = false
    @State private var jsonData: String = ""
    @State private var dateAsString: String = ""
    @State private var currentTab = 0
    @State private var isShowingScanner = false
    
    @Binding var jwt_token: String
    
    var greeting: String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        switch hour {
        case 0..<12:
            return "Good Morning!"
        case 12..<18:
            return "Good Afternoon!"
        default:
            return "Good Evening!"
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    HStack {
                        Text(greeting + "👋")
                            .font(.title)
                            .padding()
                        Spacer()
                    }
                    
                    DataRequestTileView(request_sink: $request_sink, navigateToSensorDataView: $navigateToSensorDataView, jsonData: $jsonData, dateAsString: $dateAsString, jwt_token: $jwt_token)
                    //SensorRegistrationTileView(serialID: $serialID, sinkLocation: $sinkLocation, errorMessage: $errorMessage, showAlert: $showAlert, jwt_token: $jwt_token, responseMessage: $responseMessage)
                
                    Divider()
                    TileView(sinkLocation: $sinkLocation, serialID: $serialID, errorMessage: $errorMessage, showAlert: $showAlert, jwt_token: $jwt_token, responseMessage: $responseMessage, isShowingScanner: $isShowingScanner)
                    
                    Divider()
                    GraphTileView(jwt_token: $jwt_token)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGray6))
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)  // Hides the navigation bar completely
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
        } .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DataRequestTileView: View {
    @Binding var request_sink: String
    @Binding var navigateToSensorDataView: Bool
    @Binding var jsonData: String
    @Binding var dateAsString: String
    @Binding var jwt_token: String
    
    @State private var request_date = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Request Data from a Sensor")
                .font(.headline)
                .padding(.bottom, 8)
                .foregroundStyle(.black)
            
            DatePicker("Select Date", selection: $request_date, displayedComponents: .date)
                .labelsHidden()
                .padding(.bottom, 8)
            
            TextField("Sink Location", text: $request_sink)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            Button(action: {
                getData()
                navigateToSensorDataView = true
            }) {
                Text("Get Sensor Data")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $navigateToSensorDataView) {
                SensorDataView(jsonData: jsonData, date: dateAsString)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .padding()
    }
    
    func getData() {
        dateAsString = convertDateToString(date: request_date)
        if request_sink.isEmpty {
            print("No sink specified")
            return
        }
        http_query_session(jwt: jwt_token, date: dateAsString, sinkid: request_sink) { response in
            DispatchQueue.main.async {
                jsonData = response
            }
        }
    }

    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Choose the appropriate date format
        return dateFormatter.string(from: date)
    }
}

struct TileView: View {
    @Binding var sinkLocation: String
    @Binding var serialID: String
    @Binding var errorMessage: String?
    @Binding var showAlert: Bool
    @Binding var jwt_token: String
    @Binding var responseMessage: String?
    @Binding var isShowingScanner: Bool
    @State private var currentTab = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker(selection: $currentTab, label: Text("")) {
                Text("Register").tag(0)
                Text("Unregister").tag(1)
            }
            .tint(.black)
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.top, 8)
            
            if currentTab == 0 {
                RegisterSensorView(sinkLocation: $sinkLocation, serialID: $serialID, errorMessage: $errorMessage, showAlert: $showAlert, jwt_token: $jwt_token, responseMessage: $responseMessage, isShowingScanner: $isShowingScanner)
            } else {
                UnregisterSensorView(sinkLocation: $sinkLocation, serialID: $serialID)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .padding()
    }
}

struct UnregisterSensorView: View {
    @Binding var sinkLocation: String
    @Binding var serialID: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Unregister Sensor")
                .font(.headline)
                .padding(.bottom, 8)
                .foregroundStyle(.black)
            
            TextField("Sensor ID", text: $serialID)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            TextField("Location", text: $sinkLocation)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            Button(action: {
                // Add action for unregister button
            }) {
                Text("Unregister")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
        }
    }
}

struct RegisterSensorView: View {
    @Binding var sinkLocation: String
    @Binding var serialID: String
    @Binding var errorMessage: String?
    @Binding var showAlert: Bool
    @Binding var jwt_token: String
    @Binding var responseMessage: String?
    @Binding var isShowingScanner: Bool
    @State private var isSerialIDCaptured: Bool = false
    @State private var isSuccess: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Register New Sensor")
                .font(.headline)
                .padding(.bottom, 8)
                .foregroundStyle(.black)
            
            if !isSerialIDCaptured {
                Button("Scan QR Code") {
                    isShowingScanner = true
                }
                .padding()
                .sheet(isPresented: $isShowingScanner) {
                    QRScannerView(didFindCode: { code in
                        if let data = code.data(using: .utf8),
                           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                           let scannedSerialID = json["serialID"] {
                            self.serialID = scannedSerialID
                        } else {
                            self.serialID = code
                        }
                        self.isSerialIDCaptured = true
                        self.isShowingScanner = false
                    })
                }
            } else {
                TextField("Serial ID", text: $serialID)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(true)
                    .autocapitalization(.none)

                TextField("Location", text: $sinkLocation)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                Button(action: {
                    // Check if text fields are empty
                    guard !serialID.isEmpty, !sinkLocation.isEmpty else {
                        errorMessage = "Please fill in both text fields"
                        showAlert = true
                        return
                    }
                    
                    // Call the backend function to register the sensor
                    http_register_sensor(jwt: jwt_token, sensor_id: serialID, sink_id: sinkLocation) { statusCode, message, error in
                        if let error = error {
                            // Handle error
                            print("Error: \(error.localizedDescription)")
                        } else if let statusCode = statusCode {
                            // Handle success
                            print("Status Code: \(statusCode)")
                            if let message = message {
                                // Update UI with message
                                print("Message: \(message)")
                                // Update UI with the response message
                                responseMessage = message
                                self.isSuccess = (statusCode == 201)
                                
                                if self.isSuccess {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.resetView()
                                    }
                                }
                            }
                        }
                    }
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.top, 8)
                
                if let responseMessage = responseMessage, isSuccess {
                    Text(responseMessage)
                        .foregroundColor(.green)
                        .padding(.top, 8)
                }
            }
        }
    }
    
    private func resetView() {
        self.isSerialIDCaptured = false
        self.serialID = ""
        self.sinkLocation = ""
        self.responseMessage = nil
        self.isSuccess = false
    }
}

struct DateToData: Identifiable {
    var date = ""
    var data = 0.0
    var id = UUID()
}

struct GraphTileView: View {
    @Binding var jwt_token: String
    
    @State private var request_date = Date()
    @State private var loading_graph = false
    @State private var default_str = "Loading Graph..."
    @State private var trend_data = [DateToData]()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Water Usage Over Past Week")
                .font(.headline)
                .padding(.bottom, 8)
                .foregroundStyle(.black)
            
            if !loading_graph {
                Text(default_str)
            } else {
                Chart {
                    ForEach(trend_data) { data_pair in
                        BarMark(
                            x: .value("Day", data_pair.date),
                            y: .value("Total Water Usage", data_pair.data)
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .padding()
        .onAppear {
            http_cummalative_data(date_string: convertDateToString(date: request_date),jwt: jwt_token) { created_data in
                if created_data.isEmpty {
                    loading_graph = false
                } else {
                    loading_graph = true
                    trend_data = created_data
                }
            }
        }
    }
    
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Choose the appropriate date format
        return dateFormatter.string(from: date)
    }
}
