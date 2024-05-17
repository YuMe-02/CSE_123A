import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showError = false
    @State private var showEmpty = false
    @State private var userCreationMessage = ""
    @State private var showUserCreated = false
    @State private var showUserExists = false
    @State private var jwt = ""
    @State private var response_code = 0
    @State private var isLoggingIn = false  // Track the login process

    var body: some View {
        VStack {
            if isLoggedIn {
                // Present HomeView as a full-screen cover
                HomeView(jwt_token: $jwt)
                    .edgesIgnoringSafeArea(.all)
            } else {
                NavigationView {
                    VStack {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .autocapitalization(.none)
                            .onTapGesture {
                                self.email = ""
                            }

                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .autocapitalization(.none)
                            .onTapGesture {
                                self.password = ""
                            }

                        // Button for logging in
                        Button(action: login) {
                            if isLoggingIn {
                                Text("Logging in...")
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            } else {
                                Text("Login")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                        .padding()
                        .disabled(isLoggingIn)

                        // Button to navigate to SignUpView
                        NavigationLink(destination: SignUpView(showCreatedUser: $showUserCreated, showExistsUser: $showUserExists)) {
                            Text("Sign Up")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                        .padding()

                        // Show error message if login fails
                        if showError {
                            Text("Incorrect username or password")
                                .foregroundColor(.red)
                                .padding()
                        }
                        if showEmpty {
                            Text("Empty username or password")
                                .foregroundColor(.red)
                                .padding()
                        }
                        if showUserCreated && !showUserExists {
                            Text("User has been created!")
                                .foregroundColor(.blue)
                                .padding()
                        } else if !showUserExists && showUserExists {
                            Text("User already exists")
                                .foregroundColor(.blue)
                                .padding()
                        } else {
                            Text("")
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                    .padding()
                    .navigationBarTitle("Login", displayMode: .inline)
                }
            }
        }
        .fullScreenCover(isPresented: $isLoggedIn, content: {
            HomeView(jwt_token: $jwt)
                .edgesIgnoringSafeArea(.all)
        })
    }

    func login() {
        showError = false
        showEmpty = false
        isLoggedIn = false
        isLoggingIn = true  // Start logging in process

        if email.isEmpty {
            print("Empty email")
            showEmpty = true
            isLoggingIn = false  // Reset logging in state
            return
        }
        if password.isEmpty {
            print("Empty password")
            showEmpty = true
            isLoggingIn = false  // Reset logging in state
            return
        }
        http_login_user(email: email, password: password) { response, jwt_str, error_code in
            DispatchQueue.main.async {
                if response == 201 {
                    jwt = jwt_str ?? ""
                    isLoggedIn = true
                    showError = false
                } else {
                    showError = true
                }
                isLoggingIn = false  // Reset logging in state
            }
        }
    }
}
