//
//  LoginFrontend.swift
//  water_tap_app
//
//  Created by Gary Mejia on 4/18/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showError = false
    
    var body: some View {
        if isLoggedIn {
                    HomeView()
                } else {
                    NavigationView {
                        VStack {
                            TextField("Username", text: $username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .onTapGesture {
                                    self.username = ""
                                }
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .onTapGesture {
                                    self.password = ""
                                }
                            
                            Button(action: {
                                // Simulating login logic here
                                if password == "PASSWORD" && username == "USERNAME" {
                                    self.isLoggedIn = true
                                    self.showError = false // Reset error state upon successful login
                                } else {
                                    self.showError = true
                                }
                            }) {
                                Text("Login")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            .padding()
                            
                            if showError {
                                Text("Incorrect username or password")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                        .padding()
                        .navigationBarTitle("Login", displayMode: .inline)
                    }
                }
            }
}

enum Route {
    case link1, link2
}

struct TestLogin: View {
var body: some View{
    NavigationStack {
       NavigationLink("Link1", value: Route.link1)
       NavigationLink("Link2", value: Route.link2)
           .navigationDestination(for: Route.self) { route in
               switch route {
               case .link1:
                   //https://sarunw.com/posts/hide-navigation-back-button-in-swiftui/
                   Link1().navigationBarBackButtonHidden(true)
               case .link2:
                   Link2()
               }
           }
       }
   }
}







struct Link1: View {
    var body: some View{
        Text("You are in Link1 view")
    }
}

struct Link2: View {
    var body: some View{
        Text("You are in Link2 view")
    }
}
