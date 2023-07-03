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
    @Published private(set) var error: FormError?
    @Published var hasError: Bool = false
    
    private let validator = Validator()
    func create(){
        do{
            try validator.validate(person: person)
            state = .submitting
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try? encoder.encode(person)
            
            NetworkingManager.shared.request(endpoint: .create(submissionData: data)) {[weak self] res in
                switch res{
                case .success:
                    self?.state = .successful
                case .failure(let error):
                    self?.state = .unsuccessful
                    self?.hasError = true
                    if let networkError = error as? NetworkingManager.NetworkingError{
                        self?.error = .networkingError(error: networkError )
                    }
                }
            }
        } catch{
            if let validationError = error as? Validator.validateError{
                self.hasError = true
                self.error = .validationError(error: validationError)
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
    enum FormError: LocalizedError{
        case networkingError(error : LocalizedError)
        case validationError(error : LocalizedError)
        
        var errorDescription: String?{
            switch self{
            case .networkingError(error: let err):
                return err.errorDescription
            case .validationError(error: let err):
                return err.errorDescription
            }
        }
    }
}
