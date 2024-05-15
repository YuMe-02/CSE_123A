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
            return "Good afternoon!"
        default:
            return "Good evening!"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                HStack {
                    Text(greeting + "👋")
                        .font(.title)
                        .padding()
                    Spacer()
                }
            }
            
                    
            DataRequestTileView(request_sink: $request_sink, navigateToSensorDataView: $navigateToSensorDataView, jsonData: $jsonData, dateAsString: $dateAsString, jwt_token: $jwt_token)
            //SensorRegistrationTileView(serialID: $serialID, sinkLocation: $sinkLocation, errorMessage: $errorMessage, showAlert: $showAlert, jwt_token: $jwt_token, responseMessage: $responseMessage)
        
            Divider()
            TileView(sinkLocation: $sinkLocation, serialID: $serialID, errorMessage: $errorMessage, showAlert: $showAlert, jwt_token: $jwt_token, responseMessage: $responseMessage, isShowingScanner: $isShowingScanner)
            
            Divider()
            GraphTileView(jwt_token: $jwt_token)
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
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
                SensorDataView(jsonData: jsonData)
            }
    
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .padding()
    }
    
    func getData() {
        dateAsString = convertDateToString(date: request_date)
        if request_sink.isEmpty{
            print("No sink Specified")
            return
        }
        print(dateAsString)
        print(request_sink)
        http_query_session(jwt: jwt_token, date: dateAsString, sinkid: request_sink){
            response in
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


//FOR TESTING
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
            Text("Un-Register Sensor")
                .font(.headline)
                .padding(.bottom, 8)
                .foregroundStyle(.black)
            
                .foregroundColor(.black)
            TextField("Sensor ID", text: $serialID)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Location", text: $sinkLocation)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Register New Sensor")
                .font(.headline)
                .padding(.bottom, 8)
                .foregroundStyle(.black)
            
            //TextField("Sensor ID", text: $serialID)
            //    .padding()
            //    .textFieldStyle(RoundedBorderTextFieldStyle())
            
            //TESTING QR CODE SCANNER
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
                    self.isShowingScanner = false
                })
            }
            
            TextField("Location", text: $sinkLocation)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
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
                            showAlert = true
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
        }
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
            Text("Graph of the Past Week")
                .font(.headline)
                .padding(.bottom, 8)
                .foregroundStyle(.black)
            
            if(!loading_graph){
                Text(default_str)
            } else{
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
        .onAppear{
                http_cummalative_data(jwt: jwt_token){
                    created_data in
                    if(created_data.isEmpty){
                        loading_graph = false
                    } else{
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



