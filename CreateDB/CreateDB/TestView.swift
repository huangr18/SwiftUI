//
//  TestView.swift
//  CreateDB
//
//  Created by Katherine Schaeffer (Beta) on 6/15/23.
//

import SwiftUI
import FirebaseAuth

struct TestView: View {
    @AppStorage("uid") var userID: String = ""
    
    
    var body: some View {
        
        if userID == "" {
            AuthView()
        } else {
            Text("Logged In! \nYour user id is \(userID)")
            
            Button(action: {
                let firebaseAuth = Auth.auth()
                do {
                  try firebaseAuth.signOut()
                    withAnimation {
                        userID = ""
                    }
                } catch let signOutError as NSError {
                  print("Error signing out: %@", signOutError)
                }
            }) {
                Text("Sign Out")
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
