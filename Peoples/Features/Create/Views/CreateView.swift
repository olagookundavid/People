//
//  CreateView.swift
//  Peoples
//
//  Created by David OH on 29/06/2023.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cvm = CreateViewModel()
    @FocusState private var focusedField : Field?
    let successfulAction : () -> Void
    
    var body: some View {
        NavigationView {
            Form{
                Section {
                    firstName
                    lastName
                    job
                } footer: {
                    if case .validationError(let error)
                        = cvm.error,
                       let err = error.errorDescription{
                        Text(err).foregroundColor(.red)
                    }
                }
                
                Section{
                    submit
                }
            }
            .disabled(cvm.state == .submitting)
            .navigationTitle("Create")
            .toolbar{
                ToolbarItem(placement: .primaryAction){
                    done
                }
            }
            .onChange(of: cvm.state) { formState in
                if formState == .successful{
                    dismiss()
                    successfulAction()
                }
            }
            .alert(isPresented: $cvm.hasError, error: cvm.error) {
                
            }
            .overlay{if  cvm.state == .submitting {ProgressView()}}
        }
    }
}
private extension CreateView {
    var firstName : some View{
        TextField("First Name", text: $cvm.person.firstName)
            .focused($focusedField,equals: .firstName)
    }
    
    var lastName : some View{
        TextField("Last Name", text: $cvm.person.lastName)
            .focused($focusedField,equals: .lastName)
    }
    
    var job : some View{
        TextField("Job", text: $cvm.person.job)
            .focused($focusedField,equals: .job)
    }
    
    
    var done : some View{
        Button("Done") {
            dismiss()
        }
    }
    
    var submit : some View{
        Button("Submit") {
            focusedField = nil
            Task{
               await cvm.create()
            }
            
        }
    }
}
extension CreateView {
    enum Field{
        case firstName,lastName,job
        
    }
}


struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView{}
    }
}
