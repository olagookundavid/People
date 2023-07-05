//
//  PeopleViewModel.swift
//  Peoples
//
//  Created by David OH on 30/06/2023.
//

import Foundation


final class PeopleViewModel: ObservableObject{
    @Published private(set) var users:[User] = []
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published var hasError: Bool = false
    @Published var isLoading: Bool = false
    
    @MainActor
    func fetchUsers() async {
        
        self.isLoading = true
        self.hasError = false
        defer{isLoading = false}
        do{
            let  response = try await NetworkingManager.shared.request(endpoint: .people, type: UsersResponse.self)
            self.users = response.data
        }catch{
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError{
                self.error = networkingError
            } else{
                self.error = .custom(error: error)
            }
        }
    }
}

