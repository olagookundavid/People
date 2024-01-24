//
//  CreateViewModel.swift
//  Peoples
//
//  Created by David OH on 02/07/2023.
//

import Foundation


class CreateViewModel: ObservableObject{
    @Published var person = NewPerson()
    @Published private(set) var state : SubmissionState?
    @Published private(set) var error: FormError?
    @Published var hasError: Bool = false
    
    private let networkingManager: NetworkingManagerImpl!
    private let validator: CreateValidatorImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared,
         validator: CreateValidatorImpl = Validator()) {
        self.networkingManager = networkingManager
        self.validator = validator
    }
    
    @MainActor
    func create() async{
        do{
            try validator.validate(person: person)
            state = .submitting
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try? encoder.encode(person)
            
            try await NetworkingManager.shared.request(endpoint: .create(submissionData: data))
            state = .successful
        }catch{
            self.hasError = true
            self.state = .unsuccessful
            
            switch error {
            case is NetworkingManager.NetworkingError:
                self.error = .networkingError(error: error as! NetworkingManager.NetworkingError)
            case is Validator.validateError:
                self.error = .validationError(error: error as! Validator.validateError)
            default:
                self.error = .systemError(error: error)
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
        case systemError(error : Error)
        
        var errorDescription: String?{
            switch self{
            case .networkingError(error: let err),
                    .validationError(error: let err):
                return err.errorDescription
            case .systemError(error: let err):
                return err.localizedDescription
            }
        }
    }
}
extension CreateViewModel.FormError: Equatable {
    
    static func == (lhs: CreateViewModel.FormError, rhs: CreateViewModel.FormError) -> Bool {
        switch (lhs, rhs) {
        case (.networkingError(let lhsType), .networkingError(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.validationError(let lhsType), .validationError(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.systemError(let lhsType), .systemError(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}
