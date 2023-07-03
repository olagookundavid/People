//
//  CreateValidator.swift
//  Peoples
//
//  Created by David OH on 02/07/2023.
//

import Foundation

struct Validator{
    func validate(person : NewPerson) throws {
        if person.firstName.isEmpty {
            throw validateError.invalidFirstName
        }
        if person.lastName.isEmpty {
            throw validateError.invalidLastName
        }
        if person.job.isEmpty {
            throw validateError.invalidJob 
        }
    }
}

extension Validator {
    enum validateError: LocalizedError{
        case invalidFirstName
        case invalidLastName
        case invalidJob
        
        
        var errorDescription: String?{
            switch self{
            case .invalidFirstName:
                return "First Name cannot be empty"
            case .invalidLastName:
                return "Last Name cannot be empty"
            case .invalidJob:
                return "Job cannot be empty"
            }
        }
    }}
