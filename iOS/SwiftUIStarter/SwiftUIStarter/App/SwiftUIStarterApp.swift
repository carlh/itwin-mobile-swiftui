//---------------------------------------------------------------------------------------
//
//     $Source: $
//
//  $Copyright: (c) 2021 Bentley Systems, Incorporated. All rights reserved. $
//
//---------------------------------------------------------------------------------------

import SwiftUI
import ITwinMobile

@main
struct SwiftUIStarterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private var application = SwiftUIModelApplication()
    
    var body: some Scene {
        return WindowGroup {
            Home()
                .environmentObject(application)
        }
    }
}
