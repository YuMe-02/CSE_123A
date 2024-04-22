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
    
    
    var body: some View {
        VStack {
            TextField("Email", text: $email, onCommit: resetEmailEmpty)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Username", text: $username, onCommit: resetUsernameEmpty)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password, onCommit: resetPasswordMatch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm Password", text: $confirmPassword, onCommit: resetPasswordMatch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: signUp) {
                if isSigningUp {
                    Text("Sending info to server")
                } else {
                    Text("Sign Up")
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
        }
        .padding()
        .navigationBarTitle("Sign Up", displayMode: .inline)
    }
    
    func signUp() {
        // Perform sign-up actions here
        if password == confirmPassword && !password.isEmpty && !email.isEmpty && !username.isEmpty {
            // Passwords match, proceed with sign-up
            emptyuser = true
            emptyemail = true
            isSigningUp = true
            print("send post request to server")
            // Send data to server...
        } else if password != confirmPassword {
            // Passwords don't match
            passwordsMatch = false
            print("non matching passwords")
        } else if email.isEmpty {
            emptyemail = false
            print("empty email")
        } else if username.isEmpty{
            emptyuser = false
            print("empty username")
        }
        
    }
    
    func resetPasswordMatch() {
        // Reset the passwordsMatch state when the password fields change
        passwordsMatch = true
    }
    func resetEmailEmpty() {
        emptyemail = true
    }
    
    func resetUsernameEmpty() {
        emptyuser = true
    }
}
