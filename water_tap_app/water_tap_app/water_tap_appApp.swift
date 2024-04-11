//
//  water_tap_appApp.swift
//  water_tap_app
//
//  Created by Gary Mejia on 2/20/24.
//

import SwiftUI
import UIKit

//basic test of our iphone api
func http_get_request_test(completion: @escaping (String) -> Void) {
    let url = URL(string: "https://cse123-flowsensor-server.com/api/iphone-test")!
    var empty_string: String = ""
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            print("get request failed")
            completion(empty_string) // Call completion handler with empty string
            return
        }
        empty_string = String(data: data, encoding: .utf8) ?? ""
        print(empty_string)
        completion(empty_string) // Call completion handler with data string
    }
    task.resume()
}

@main
struct water_tap_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
