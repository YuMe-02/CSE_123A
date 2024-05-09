//
//  HomeFrontend.swift
//  water_tap_app
//
//  Created by Gary Mejia on 4/18/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var serialID: String = ""
    @State private var sinkLocation: String = ""
    @State private var request_date = Date()
    @State private var request_sink: String = ""
    @State private var errorMessage: String?
    @State private var responseMessage: String?
    @State private var showAlert = false
    @State private var navigateToSensorDataView = false
    @State private var jsonData: String = ""
    @State private var dateAsString: String = ""
    
    
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
        VStack(alignment: .leading, spacing: 5) {
            Text(greeting + "👋")
                .bold()
                .font(.title)
                .foregroundColor(.blue)
                .padding(5)
            
            
            Section(header: Text("**Register New Sensor**")) {
                TextField("Serial ID", text: $serialID)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Sink Location", text: $sinkLocation)
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
                    Text("Send Request")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(""), message: Text(responseMessage ?? ""), dismissButton: .default(Text("OK")))
                }
            }
            .padding(20)
            
            Divider()
            
            Section(header: Text("**Request Data for Specific Day**")) {
                DatePicker("Request Date", selection: $request_date, displayedComponents: .date)
                    .padding()
                    .datePickerStyle(DefaultDatePickerStyle())
                TextField("Request Sink", text: $request_sink)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            Spacer()
            }
            .padding(5)
            
            Button(action: {
                getData()
                navigateToSensorDataView = true
            }) {
                Text("get Sensor Data")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $navigateToSensorDataView) {
                SensorDataView(jsonData: jsonData)
            }
            
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarTitle("Home")
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
