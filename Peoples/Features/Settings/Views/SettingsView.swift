//
//  SettingsView.swift
//  Peoples
//
//  Created by David OH on 03/07/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(UserDefaultsKeys.hapticsEnabled) private var isHapticEnabled: Bool = true
    var body: some View {
        NavigationView{
            Form{
                haptics
            }
            .navigationTitle("Settings")
        }
    }
}

private extension SettingsView{
    var haptics: some View{
        Toggle("Enable Haptics", isOn: .constant(true))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
