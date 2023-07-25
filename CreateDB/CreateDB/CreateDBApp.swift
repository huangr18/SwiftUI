//
//  CreateDBApp.swift
//  CreateDB
//
//  Created by Katherine Schaeffer (Beta) on 6/14/23.
//

import SwiftUI
import Firebase

@main
struct CreateDBApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            TestView()
        }
    }
}
