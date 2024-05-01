//
//  SignUpView.swift
//  water_tap_app
//
//  Created by Gary Mejia on 4/21/24.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSigningUp = false
    @State private var passwordsMatch = true
    @State private var emptyemail = true
    @State private var emptyuser = true
    @State private var errorMessage = ""
    @State private var signResponse = 0
    @Binding var showCreatedUser: Bool
    @Binding var showExistsUser: Bool
    @State private var navigateToLogin = false
    
    var body: some View {
        VStack {
            TextField("Email", text: $email, onCommit: resetEmailEmpty)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .onTapGesture {
                    self.email = ""
                }
            
            TextField("Username", text: $username, onCommit: resetUsernameEmpty)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .onTapGesture {
                    self.username = ""
                }
            
            SecureField("Password", text: $password, onCommit: resetPasswordMatch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .onTapGesture {
                    self.password = ""
                }
            
            SecureField("Confirm Password", text: $confirmPassword, onCommit: resetPasswordMatch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none)
                .onTapGesture {
                    self.confirmPassword = ""
                }
            Button(action: signUp) {
                Text("Sign Up")
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding()
            
            if !passwordsMatch && confirmPassword.isEmpty {
                Text("Passwords don't match")
                    .foregroundColor(.red)
                    .padding()
            }
            if !emptyuser {
                Text("Enter a username!")
                    .foregroundColor(.red)
                    .padding()
            }
            if !emptyemail {
                Text("Enter an email address!")
                    .foregroundColor(.red)
                    .padding()
            }
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if signResponse == 201 {
                Text("User created successfully. Go back to login.")
                    .foregroundColor(.blue)
                    .padding()
            } else if signResponse == 202 {
                Text("User already exists. Go back to login.")
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .padding()
    }
    
    func resetPasswordMatch() {
        passwordsMatch = true
    }
    
    func resetEmailEmpty() {
        emptyemail = true
    }
    
    func resetUsernameEmpty() {
        emptyuser = true
    }
    
    func signUp() {
        if password == confirmPassword && !password.isEmpty && !email.isEmpty && !username.isEmpty {
            emptyuser = true
            emptyemail = true
            isSigningUp = true
            http_create_user(email: email, username: username, password: password) { response in
                DispatchQueue.main.async {
                    isSigningUp = false
                    print(response)
                    signResponse = response
                    if response == 201 {
                        // Successful sign-up, navigate back to login view
                        // You may need to implement navigation here
                        print("Sign-up successful")
                    } else if response == 202 {
                        print("User already exists")
                    } else {
                        // Error occurred
                        errorMessage = "Error creating user. Please try again."
                        print("Error creating user")
                    }
                }
            }
        } else if password != confirmPassword {
            passwordsMatch = false
        } else if email.isEmpty {
            emptyemail = false
        } else if username.isEmpty {
            emptyuser = false
        }
    }
}
