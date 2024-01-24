//
//  PeoplesApp.swift
//  Peoples
//
//  Created by David OH on 22/06/2023.
//

import SwiftUI

@main
struct PeoplesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            TabView {
                PeopleView()
                    .tabItem {
                    Symbols.person
                    Text("Home")
                }
                .tag(0)
                SettingsView()
                    .tabItem {
                    Symbols.gear
                    Text("Settings")
                }
                .tag(1)
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if DEBUG
        print("👷🏾‍♂️ Is UI Test Running: \(UITestingHelper.isUITesting)")
        #endif
        return true
    }
}
