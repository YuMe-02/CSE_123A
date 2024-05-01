//
//  HomeFrontend.swift
//  water_tap_app
//
//  Created by Gary Mejia on 4/18/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var responseData1: String = ""
    @State private var responseData2: String = ""
    @Binding var jwt_token: String
    
    var body: some View {
        VStack {
            // Test 1
            VStack {
                Text("JWT Token is Below:")
                Text(jwt_token)
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Test1 of our iPhone API")
                if responseData1.isEmpty {
                    Text("Loading...") // Show loading text while fetching data
                } else {
                    Text(responseData1.isEmpty ? "Bad request" : responseData1)
                }
            }
            
            // Start a new VStack for additional content
            VStack {
                Image(systemName: "checkmark")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Test2 of our iPhone API")
                if responseData2.isEmpty {
                    Text("Loading...") // Show loading text while fetching data
                } else {
                    Text(responseData2.isEmpty ? "Bad request" : responseData2)
                }
            }.padding()
        }
        .onAppear {
            http_get_request_test1 { result in
                DispatchQueue.main.async {
                    self.responseData1 = result
                }
            }
            http_get_request_test2(jwt: jwt_token) { result2 in
                DispatchQueue.main.async {
                    self.responseData2 = result2
                }
            }
        }
    }
}
