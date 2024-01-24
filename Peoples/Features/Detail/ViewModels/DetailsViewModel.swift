//
//  DetailsViewModel.swift
//  Peoples
//
//  Created by David OH on 30/06/2023.
//

import Foundation
import SwiftUI

//class AuthViewModel: ObservableObject {
//    @AppStorage("accessToken") var accessToken: String?
//
//    static let shared = AuthViewModel()
//}
//let authViewModel = AuthViewModel.shared
////let anotherViewModel = AnotherViewModel(authViewModel: authViewModel)
//let token = authViewModel.accessToken // Access token is available here


final class DetailViewModel: ObservableObject{
    @Published private(set) var userInfo : UserDetailResponse?
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published var hasError: Bool = false
    @Published var isLoading: Bool = false
    private let networkingManager: NetworkingManagerImpl!
    
    init(networkingManager: NetworkingManagerImpl = NetworkingManager.shared) {
        self.networkingManager = networkingManager
    }
    @MainActor
    func fetchUsers(userId: Int) async{
        
        isLoading = true
        defer{isLoading = false}
        do{
            self.userInfo = try await networkingManager.request(session: .shared, endpoint: .detail(id: userId), type: UserDetailResponse.self)
            
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
  
