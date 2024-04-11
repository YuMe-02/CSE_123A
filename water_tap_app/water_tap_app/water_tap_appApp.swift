//
//  water_tap_appApp.swift
//  water_tap_app
//
//  Created by Gary Mejia on 2/20/24.
//

import SwiftUI
import HTTPTypes //needed for http requests
import UIKit

//For http stuff
//https://github.com/apple/swift-http-types

func http_get_request_test () -> String {
    let url = URL(string: "https://cse123-flowsensor-server.com/api/iphone-test")!
    var empty_string : String = ""
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard let data = data else {
            print("get requst failed")
            return
        }
        print("in urlsession line")
        print("data should be: " + String(data: data, encoding: .utf8)!)
        if empty_string == "" {
            print("empty_string should be correctly empty")
        } else {
            print("empty_string has elements in it rn and is an error!")
        }
        empty_string = String(data: data, encoding: .utf8) ?? ""
        if empty_string != "" {
            print("empty_string should correctly have data: " + empty_string)
        } else {
            print("empty_string is empty! error!")
        }
    }
    task.resume()
    print()
    print("after task resume")
    if empty_string != "" {
        print("empty_string should correctly have data: " + empty_string)
    } else {
        print("empty_string is empty! error!")
    }
    return empty_string
}

@main
struct water_tap_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
