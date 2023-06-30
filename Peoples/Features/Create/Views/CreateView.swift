//
//  CreateView.swift
//  Peoples
//
//  Created by David OH on 29/06/2023.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            Form{
                firstName
                lastName
                job
                
                Section{
                    submit
                }
            }.navigationTitle("Create")
                .toolbar{
                    ToolbarItem(placement: .primaryAction){
                        done
                    }
                }
        }
    }
}
private extension CreateView {
    var firstName : some View{
        TextField("First Name", text: .constant(""))
    }
    
    var lastName : some View{
        TextField("Last Name", text: .constant(""))
    }
    
    var job : some View{
        TextField("Job", text: .constant(""))
    }
    
    
    var done : some View{
        Button("Done") {
            dismiss()
        }
    }
    
    
    
    var submit : some View{
        Button("Submit") {
            
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
