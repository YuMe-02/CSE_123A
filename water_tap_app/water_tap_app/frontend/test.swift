//
//  test.swift
//  water_tap_app
//
//  Created by Darren Yu on 4/30/24.
//

import Foundation
import SwiftUI

struct TestView: View {
    var body: some View {
        
        VStack{
            Text("Our playground")
        }.onAppear{ http_query_session(jwt: "", date: "04-29-23", sinkid: "kitchen") { response in
            DispatchQueue.main.async {
                print(response)
                }
            }
        }
       
    }
    
   
}
