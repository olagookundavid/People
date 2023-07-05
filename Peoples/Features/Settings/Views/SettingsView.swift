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
            Form{
                haptics
            }
            .navigationTitle("Settings")
            .embedInNavigation()
        
    }
}

private extension SettingsView{
    var haptics: some View{
        Toggle("Enable Haptics", isOn: $isHapticEnabled)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
