//
//  NavigationExt.swift
//  Peoples
//
//  Created by David OH on 05/07/2023.
//

import SwiftUI

extension View{
    @ViewBuilder
    func embedInNavigation() -> some View{
        if #available(iOS 16, *){
            NavigationStack{
                self
            }
        } else{
            NavigationView{
            self
                
            }
            
        }
    }
}
