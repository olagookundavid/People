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
            PeopleView()
                .tabItem {
                Symbols.person
                Text("Home")
            }
                .tag(1)
        }
    }
}
