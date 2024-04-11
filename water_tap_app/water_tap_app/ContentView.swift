//
//  ContentView.swift
//  water_tap_app
//
//  Created by Gary Mejia on 2/20/24.
//

import SwiftUI

struct ContentView: View  {
    @State private var responseData: String = ""
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Test of our iPhone API")
            if responseData.isEmpty {
                           Text("Loading...") // Show loading text while fetching data
                       } else {
                           Text(responseData.isEmpty ? "Bad request" : responseData)
                       }
                   }
                   .onAppear {
                       http_get_request_test { result in
                           DispatchQueue.main.async {
                               self.responseData = result
                           }
                       }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

