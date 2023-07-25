//
//  SignupView.swift
//  CreateDB
//
//  Created by Katherine Schaeffer (Beta) on 6/15/23.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @Binding var currentShowingView: String
    @AppStorage("uid") var userID: String = ""
    
    @State private var email = ""
    @State private var password = ""
    
    private func isValidPassword(_ password: String) -> Bool {
        // min 6 char
        // 1 upper char
        // 1 special char
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous).foregroundStyle(.linearGradient(colors: [.brown, .yellow], startPoint: .leading, endPoint: .bottomTrailing))
                .frame(width: 1600, height: 900)
                .rotationEffect(.degrees(135))
                .offset(y: 350)
            
            RoundedRectangle(cornerRadius: 30, style:.continuous)
                .foregroundStyle(.linearGradient(colors: [.red, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
            
            VStack {
                Text("Create an Account!")
                    .foregroundColor(.black)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .padding(.bottom)
                    .offset(y: -120)
                
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                        .foregroundColor(.black)
                        .textFieldStyle(.plain)
                        .placeholder(when: email.isEmpty) {
                            Text("Email")
                                .foregroundColor(.black)
                                .bold()
                        }
                    
                    Spacer()
                    
                    if(email.count != 0) {
                        
                        Image(systemName: email.isValidEmail() ? "checkmark" : "wrongwaysign.fill")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                        
                    }
                }
                
                Rectangle()
                    .frame(width:350, height: 1)
                    .foregroundColor(.black)
                    .padding(.bottom)
                    .bold()
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                        .foregroundColor(.black)
                        .textFieldStyle(.plain)
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.black)
                                .bold()
                        }
                    Spacer()
                    
                    if(password.count != 0) {
                        
                        Image(systemName: isValidPassword(password) ? "checkmark" : "wrongwaysign.fill")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) ? .green: .red)
                        
                    }
                }
                Rectangle()
                    .frame(width:350, height: 1)
                    .foregroundColor(.black)
                    .bold()
                
                Button {
                    Auth.auth().createUser(withEmail: email, password: password) {
                        authResult, error in if let error = error {
                            print(error)
                            return
                        }
                        if let authResult = authResult {
                            print(authResult.user.uid)
                            userID = authResult.user.uid
                        }
                    }
                } label: {
                    Text("Create New Account")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style:.continuous)
                                .fill(.linearGradient(colors: [.green, .yellow], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.black)
                }
                .padding(.top)
                .offset(y: 100)
                
                Button {
                    withAnimation {
                        self.currentShowingView = "login"
                    }
                } label: {
                    Text("Already have an account?")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y: 100)
                
            }
            .frame(width: 350)
        }
        .ignoresSafeArea()
    }
}
