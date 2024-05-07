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
        VStack(alignment: .leading, spacing: 20) {
            Text(greeting + "👋")
                .bold()
                .font(.title)
                .foregroundColor(.blue)
                .padding()
            
            Section(header: Text("**Register New Sensor**")) {
                TextField("Serial ID", text: $serialID)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Sink Location", text: $sinkLocation)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    
                }) {
                    Text("Send Request")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            Divider()
            Section(header: Text("**Request Data for Specific Day**")) {
                DatePicker("Request Date", selection: $request_date, displayedComponents: .date)
                        .padding()
                        .datePickerStyle(DefaultDatePickerStyle())
                TextField("Request Sink", text: $request_sink)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Spacer()
        }
        .padding()
    }
}
