//
//  http_handling.swift
//  water_tap_app
//
//  Created by Gary Mejia on 4/18/24.
//

import Foundation

//basic test of our iphone api for test 1
func http_get_request_test1(completion: @escaping (String) -> Void) {
    let url = URL(string: "https://cse123-flowsensor-server.com/api/iphone-test")!
    var empty_string: String = ""
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            print("get request failed")
            completion(empty_string) // Call completion handler with empty string
            return
        }
        empty_string = String(data: data, encoding: .utf8) ?? ""
        //print(empty_string)
        completion(empty_string) // Call completion handler with data string
    }
    task.resume()
}

//basic test of our iphone api for test 2
func http_get_request_test2(completion: @escaping (String) -> Void) {
    let url = URL(string: "https://cse123-flowsensor-server.com/api/iphone-test-2")!
    var empty_string: String = ""
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            print("get request failed")
            completion(empty_string) // Call completion handler with empty string
            return
        }
        empty_string = String(data: data, encoding: .utf8) ?? ""
        //print(empty_string)
        completion(empty_string) // Call completion handler with data string
    }
    task.resume()
}
