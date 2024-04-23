//
//  http_handling.swift
//  water_tap_app
//
//  Created by Gary Mejia on 4/18/24.
//

import Foundation

struct SignUpData: Encodable {
    let name: String
    let email: String
    let password: String
}
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

func http_create_user(email: String, username: String, password: String, completion: @escaping (String) -> Void){
    let url = URL(string: "https://cse123-flowsensor-server.com/signup")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Construct dictionary with parameters
    let parameters: [String: Any] = [
        "name": username,
        "email": email,
        "password": password
    ]
    
    // Serialize dictionary into JSON data
    guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
        completion("Failed to serialize parameters")
        return
    }
    
    // Set request body
    request.httpBody = jsonData
    
    // Set request headers to indicate JSON content
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion("Error: \(error.localizedDescription)")
            return
        }
        
        guard let data = data else {
            completion("No data returned")
            return
        }
        
        if let responseString = String(data: data, encoding: .utf8) {
            completion(responseString)
        } else {
            completion("Unable to parse response data")
        }
    }
    task.resume()
}

