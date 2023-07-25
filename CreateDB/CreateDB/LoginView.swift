//
//  ContentView.swift
//  CreateDB
//
//  Created by Katherine Schaeffer (Beta) on 6/14/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @Binding var currentShowingView: String
    @AppStorage("uid") var userID: String = ""
    
    @State private var email = ""
    @State private var password = ""
    @State var wrongpass = false
    
    private func isValidPassword(_ password: String) -> Bool {
        // min 6 char
        // 1 upper char
        // 1 special char
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ZStack {
            Color.black
            
            RoundedRectangle(cornerRadius: 30, style:.continuous)
                .foregroundStyle(.linearGradient(colors: [.green, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1200, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -366)
            
            VStack {
                Text("Welcome")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -100, y: -100)
                
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .placeholder(when: email.isEmpty) {
                            Text("Email")
                                .foregroundColor(.white)
                                .bold()
                        }
                    
                    Spacer()
                    
                    if(email.count != 0) {
                        
                        Image(systemName: email.isValidEmail() && !wrongpass ? "checkmark" : "wrongwaysign.fill")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() && !wrongpass ? .green : .red)
                    }
                }
                
                Rectangle()
                    .frame(width:350, height: 1)
                    .foregroundColor(.white)
                    .padding(.bottom)
                    .bold()
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.white)
                                .bold()
                        }
                    Spacer()
                    
                    if(password.count != 0) {
                        Image(systemName: isValidPassword(password) && !wrongpass ? "checkmark" : "wrongwaysign.fill")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) && !wrongpass ? .green: .red)
                        
                    }
                }
                Rectangle()
                    .frame(width:350, height: 1)
                    .foregroundColor(.white)
                    .bold()
                
                if (wrongpass) {
                    Text("Wrong email or password!")
                        .foregroundColor(.red)
                }
                
                Button {
                    login()
                    
                } label: {
                    Text("Login")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style:.continuous)
                                .fill(.linearGradient(colors: [.yellow, .pink], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.black)
                }
                .padding(.top)
                .offset(y: 100)
                
                Button {
                   // register()
                    withAnimation {
                        self.currentShowingView = "signup"
                    }
                } label: {
                    Text("Don't have an account? Sign Up")
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
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) {
            authResult, error in if let error = error {
                print(error)
                wrongpass = true
                return
            }
            if let authResult = authResult {
                print(authResult.user.uid)
                withAnimation{
                    userID = authResult.user.uid
                }
            }
        }
    }
    
//    func register() {
//        Auth.auth().createUser(withEmail: email, password: password) {
//            result, error in if error != nil {
//                print(error!.localizedDescription)
//            }
//        }
//    }
    
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
