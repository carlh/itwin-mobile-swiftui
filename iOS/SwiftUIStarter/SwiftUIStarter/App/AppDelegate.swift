//
//  AppDelegate.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/27/21.
//

import UIKit
import AppAuth
import AppAuthCore

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let currentAuthFlow = AppAuthHelper.currentAuthorizationFlow, currentAuthFlow.resumeExternalUserAgentFlow(with: url) {
            AppAuthHelper.currentAuthorizationFlow = nil
            return true
        }
        return false
    }
}
