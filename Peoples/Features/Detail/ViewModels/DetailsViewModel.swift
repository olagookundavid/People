//
//  DetailsViewModel.swift
//  Peoples
//
//  Created by David OH on 30/06/2023.
//

import Foundation


final class DetailViewModel: ObservableObject{
    @Published private(set) var userInfo : UserDetailResponse?
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published var hasError: Bool = false
    @Published var isLoading: Bool = false
    
    @MainActor
    func fetchUsers(userId: Int) async{
        
        isLoading = true
        defer{isLoading = false}
        do{
            self.userInfo = try await NetworkingManager.shared.request(endpoint: .detail(id: userId), type: UserDetailResponse.self)
            
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
  
