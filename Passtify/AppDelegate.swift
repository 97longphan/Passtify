//
//  AppDelegate.swift
//  Passtify
//
//  Created by LONGPHAN on 29/4/25.
//

import FirebaseCore
import SwiftUI
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        firebaseConfigure()
        gidConfigure()
        
        return true
    }
    
    private func firebaseConfigure() {
        FirebaseApp.configure()
    }
    
    private func gidConfigure() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
}
