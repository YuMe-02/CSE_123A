//
//  water_tap_appApp.swift
//  water_tap_app
//
//  Created by Gary Mejia on 2/20/24.
//

import SwiftUI
import HTTPTypes //needed for http requests
//For http stuff
//https://github.com/apple/swift-http-types

func http_request (method: String, uri: String) -> String {
    let request = method + " /" + uri + " HTTP/1.1\r\n\r\n"
    //let request = HTTPRequest(method: .get, scheme: "https", authority: //"https://cse123-flowsensor-server.com/", path: "/api/iphone-test")
    return request
}

@main
struct water_tap_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
