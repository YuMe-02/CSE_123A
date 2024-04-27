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
        if navigateToLogin {
            NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                EmptyView()
            }
        } else {
            VStack {
                TextField("Email", text: $email, onCommit: resetEmailEmpty)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                TextField("Username", text: $username, onCommit: resetUsernameEmpty)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password, onCommit: resetPasswordMatch)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                SecureField("Confirm Password", text: $confirmPassword, onCommit: resetPasswordMatch)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
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
            }
            .padding()
        }
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
            // Simulating sign-up response
            signResponse = Int.random(in: 201...202)
            if signResponse == 201 {
                showCreatedUser = true
                showExistsUser = false
                errorMessage = ""
                navigateToLogin = true // Navigate to LoginView upon successful sign-up
            } else if signResponse == 202 {
                showCreatedUser = false
                showExistsUser = true
                errorMessage = ""
                navigateToLogin = true // Navigate to LoginView upon successful sign-up
            } else {
                // Error occurred
                showCreatedUser = false
                showExistsUser = false
                errorMessage = "Error creating user. Please try again."
                print("Error creating user")
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
