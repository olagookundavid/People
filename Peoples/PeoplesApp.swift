//
//  PeoplesApp.swift
//  Peoples
//
//  Created by David OH on 22/06/2023.
//

import SwiftUI

@main
struct PeoplesApp: App {
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
