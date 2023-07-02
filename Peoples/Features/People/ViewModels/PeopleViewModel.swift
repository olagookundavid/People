//
//  PeopleViewModel.swift
//  Peoples
//
//  Created by David OH on 30/06/2023.
//

import Foundation

@MainActor
final class PeopleViewModel: ObservableObject{
    @Published private(set) var users:[User] = []
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published var hasError: Bool = false
    @Published var isLoading: Bool = false
    
    
    func fetchUsers(){
        isLoading = true
        NetworkingManager.shared.request(absUrl: "https://reqres.in/api/users/", type: UsersResponse.self) {[weak self] res in
            
            switch res{
            case .success(let response):
                self?.users = response.data
                self?.isLoading = false
            case .failure(let error):
                self?.hasError = true
                self?.error = error as? NetworkingManager.NetworkingError
                self?.isLoading = false
            } 
        }
    }
}

