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
    
       var body: some View {
           
           NavigationStack {
                       VStack {
                           //username box
                           TextField("Username", text: $username)
                               .textFieldStyle(RoundedBorderTextFieldStyle())
                               .padding()
                           //password box
                           SecureField("Password", text: $password)
                               .textFieldStyle(RoundedBorderTextFieldStyle())
                               .padding()
                           
                           Button(action: {
                               // Simulating login logic here
                               if password == "your_valid_password" {
                                   self.isLoggedIn = true
                               }
                           }) {
                               Text("Login")
                                   .padding()
                                   .background(Color.blue)
                                   .foregroundColor(.white)
                                   .cornerRadius(5)
                           }
                           .padding()
                           
                           NavigationLink(
                               destination: ContentView(),
                               isActive: $isLoggedIn,
                               label: { EmptyView() }
                           )
                           .isDetailLink(false) // Prevents the back button from appearing on the destination view
                       }
                       .padding()
                       .navigationTitle("Login")
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
