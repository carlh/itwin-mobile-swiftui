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
    
//    private var application = ModelApplication()
    
    var body: some Scene {
        return WindowGroup {
//            ITMSwiftUIContentView(application: application)
//                .edgesIgnoringSafeArea(.all)
//                .onOpenURL() { url in
//                    DocumentHelper.openInboxUrl(url)
//                }
            Home()
        }
    }
}
