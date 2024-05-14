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

struct SensorRegisterData: Encodable {
    let sensor_id: String
    let sink_id: String
}


//Function to register new sensor
func http_register_sensor(jwt: String, sensor_id: String, sink_id: String, completion: @escaping (Int?, String?, Error?) -> Void) {
    let url = URL(string: "https://cse123-flowsensor-server.com/api/sensors/register")! // Corrected endpoint for login
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let parameters: [String: Any] = [
        "sensor_id": sensor_id,
        "sink_id": sink_id
    ]
    //add jwt
    request.addValue("\(jwt)", forHTTPHeaderField: "x-access-token")
    // Serialize dictionary into JSON data
    guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
        completion(nil, nil, NSError(domain: "Serialization", code: -1, userInfo: nil)) // Return error code for failed serialization
        return
    }
    // Set request body
    request.httpBody = jsonData
    
    // Set request headers to indicate JSON content
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(nil, nil, error) // Return error from URLSession error
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(nil, nil, NSError(domain: "Response", code: -2, userInfo: nil)) // Return error for invalid response
            return
        }
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                // try to read out a string array
                let message = json["message"]
                completion(httpResponse.statusCode, message as? String, nil)
                }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            completion(nil, nil, NSError(domain: "Response", code: -2, userInfo: nil))
        }
    }
    
    task.resume()
}

func http_login_user(email: String, password: String, completion: @escaping (Int?, String?, Error?) -> Void) {
    let url = URL(string: "https://cse123-flowsensor-server.com/login")! // Corrected endpoint for login
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let parameters: [String: Any] = [
        "email": email,
        "password": password
    ]
    // Serialize dictionary into JSON data
    guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
        completion(nil, nil, NSError(domain: "Serialization", code: -1, userInfo: nil)) // Return error code for failed serialization
        return
    }
    // Set request body
    request.httpBody = jsonData
    
    // Set request headers to indicate JSON content
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(nil, nil, error) // Return error from URLSession error
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(nil, nil, NSError(domain: "Response", code: -2, userInfo: nil)) // Return error for invalid response
            return
        }
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                // try to read out a string array
                let token_temp = json["token"]
                completion(httpResponse.statusCode, token_temp as? String, nil)
                }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            completion(nil, nil, NSError(domain: "Response", code: -2, userInfo: nil))
        }
    }
    
    task.resume()
}

func http_create_user(email: String, username: String, password: String, completion: @escaping (Int) -> Void) {
    if !valid_email(email: email) {
        print("Invalid email")
        completion(-1) // Return error code -1 for invalid email
        return
    }
    if !valid_username(username: username) {
        print("Invalid username")
        completion(-2) // Return error code -2 for invalid username
        return
    }
    if !valid_password(password: password) {
        print("Invalid password")
        completion(-3) // Return error code -3 for invalid password
        return
    }
    
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
        completion(-4) // Return error code -4 for failed serialization
        return
    }
    // Set request body
    request.httpBody = jsonData
    
    // Set request headers to indicate JSON content
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error as NSError? {
            completion(error.code) // Return error code from NSError
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(-5) // Return error code -5 for invalid response
            return
        }
        
        completion(httpResponse.statusCode) // Return HTTP status code
    }
    task.resume()
}

func valid_password(password: String) -> Bool {
    // Password must be greater than or equal to 8 characters
    guard password.count >= 8 else {
        return false
    }

    // Check if the password contains at least one lowercase letter
    let lowercaseLetters = CharacterSet.lowercaseLetters
    let passwordCharacterSet = CharacterSet(charactersIn: password)
    guard passwordCharacterSet.intersection(lowercaseLetters).isEmpty == false else {
        return false
    }

    // Check if the password contains at least one uppercase letter
    let uppercaseLetters = CharacterSet.uppercaseLetters
    guard passwordCharacterSet.intersection(uppercaseLetters).isEmpty == false else {
        return false
    }

    // Check if the password contains at least one digit
    let digits = CharacterSet.decimalDigits
    guard passwordCharacterSet.intersection(digits).isEmpty == false else {
        return false
    }

    // Check if the password contains at least one special character
    let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_-=+")
    guard passwordCharacterSet.intersection(specialCharacters).isEmpty == false else {
        return false
    }

    return true
}

func valid_username(username: String) -> Bool {
    // Username must be greater than or equal to 8 characters
    guard username.count >= 8 else {
        return false
    }

    // Check if the username contains at least one letter (uppercase or lowercase)
    let letters = CharacterSet.letters
    let usernameCharacterSet = CharacterSet(charactersIn: username)
    guard usernameCharacterSet.intersection(letters).isEmpty == false else {
        return false
    }

    return true
}

func valid_email(email: String) -> Bool {
    // Regular expression for validating email address
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    // Create NSPredicate with format matching emailRegex
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    
    // Evaluate the predicate with the email string
    return emailPredicate.evaluate(with: email)
}

func http_query_session(jwt: String, date: String, sinkid: String, completion: @escaping (String) -> Void) {
    let endpoint = "https://cse123-flowsensor-server.com/api/user-data?" + "date=" + date + "&" + "sink_id=" + sinkid
    print("The expected enpoint is: " + endpoint)
    let url = URL(string: endpoint)!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("\(jwt)", forHTTPHeaderField: "x-access-token")
    var empty_string: String = ""
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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

