//
//  ContentView.swift
//  water_tap_app
//
//  Created by Gary Mejia on 2/20/24.
//

import SwiftUI

struct ContentView: View  {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Test")
            let test = http_get_request_test()
            if test == "" {
                Text("Bad Request")
            } else{
                Text(test)
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

