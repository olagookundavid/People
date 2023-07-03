//
//  DetailsViewModel.swift
//  Peoples
//
//  Created by David OH on 30/06/2023.
//

import Foundation

@MainActor
final class DetailViewModel: ObservableObject{
    @Published private(set) var userInfo : UserDetailResponse?
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published var hasError: Bool = false
    @Published var isLoading: Bool = false
    
    
    func fetchUsers(userId: Int){
        isLoading = true
        NetworkingManager.shared.request(endpoint: .detail(id: userId), type: UserDetailResponse.self) {[weak self] res in
            
            
            switch res{
            case .success(let response):
                self?.userInfo  = response
                self?.isLoading = false
            case .failure(let error):
                self?.hasError = true
                self?.error = error as? NetworkingManager.NetworkingError
                self?.isLoading = false
            }
        }
    }
}
  
