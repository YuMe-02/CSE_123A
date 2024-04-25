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

    var body: some View {
        VStack {
            TextField("Email", text: $email, onCommit: resetEmailEmpty)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none) // Disable autocapitalization
            
            TextField("Username", text: $username, onCommit: resetUsernameEmpty)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none) // Disable autocapitalization
            
            SecureField("Password", text: $password, onCommit: resetPasswordMatch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none) // Disable autocapitalization
            
            SecureField("Confirm Password", text: $confirmPassword, onCommit: resetPasswordMatch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.none) // Disable autocapitalization
            
            Button(action: signUp) {
                Text("Sending info to server")
                if(self.signResponse == 201){
                    //go to login view
                    LoginView()
                    //display in text in the LoginView that user is created
                } else if(self.signResponse == 202){
                    //go to login view
                    LoginView()
                    //display in text in the LoginView that user already exists
                } else{
                    Text("User Creation Failed! Try Again!")
                }
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
        .navigationBarTitle("Sign Up", displayMode: .inline)
    }
    
    func signUp() {
        if password == confirmPassword && !password.isEmpty && !email.isEmpty && !username.isEmpty {
            emptyuser = true
            emptyemail = true
            isSigningUp = true
            http_create_user(email: email, username: username, password: password) { response in
                DispatchQueue.main.async {
                    isSigningUp = false
                    self.signResponse = response
                    print("Response code is: ", response)
                    if response == 201 {
                        // Successful sign-up, navigate back to login view
                        // You may need to implement navigation here
                        print("Sign-up successful")
                    } else if response == 202 {
                        print("User exists")
                    }
                    else {
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
    
    func resetPasswordMatch() {
        passwordsMatch = true
    }
    
    func resetEmailEmpty() {
        emptyemail = true
    }
    
    func resetUsernameEmpty() {
        emptyuser = true
    }
}
