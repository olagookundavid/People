//
//  CreateViewModel.swift
//  Peoples
//
//  Created by David OH on 02/07/2023.
//

import Foundation

@MainActor
class CreateViewModel: ObservableObject{
    @Published var person = NewPerson()
    @Published private(set) var state : SubmissionState?
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published var hasError: Bool = false
    
    func create(){
        state = .submitting 
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(person)
        
        NetworkingManager.shared.request(methodtype: .post(data: data),absUrl: "https://reqres.in/api/users") {[weak self] res in
            switch res{
            case .success:
                self?.state = .successful
            case .failure(let error):
                self?.state = .unsuccessful
                self?.hasError = true
                self?.error = error as? NetworkingManager.NetworkingError
            }
        }
        
    }
}

extension CreateViewModel {
    enum SubmissionState{
        case unsuccessful
        case successful
        case submitting
    }
}
