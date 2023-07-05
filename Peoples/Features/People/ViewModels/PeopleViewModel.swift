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
    @Published var viewState: ViewState?
    private var page: Int = 1
    private var totPage: Int?
    var isLoading: Bool {
        viewState == .loading
    }
    var isFetching: Bool{
        viewState == .fetching
    }
    @MainActor
    func fetchUsers() async {
        reset()
        self.viewState = .loading
        self.hasError = false
        defer{self.viewState = .finished}
        do{
            let  response = try await NetworkingManager.shared.request(endpoint: .people(page: page), type: UsersResponse.self)
            self.totPage = response.totalPages
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
    
    @MainActor
    func fetchNextUsers() async {
        guard page != totPage else{
            return
        }
        self.viewState = .fetching
        self.hasError = false
        defer{self.viewState = .finished}
        page += 1
        do{
            let  response = try await NetworkingManager.shared.request(endpoint: .people(page: page), type: UsersResponse.self)
            self.totPage = response.totalPages
            self.users += response.data
        }catch{
            self.hasError = true
            if let networkingError = error as? NetworkingManager.NetworkingError{
                self.error = networkingError
            } else{
                self.error = .custom(error: error)
            }
        }
    }
    
    func hasReachedEnd(user: User) -> Bool{
        users.last?.id == user.id
    }
}

extension PeopleViewModel{
    enum ViewState{
        case fetching,loading,finished
    }
    @MainActor
    func reset(){
        if viewState == .finished{
            users.removeAll()
            page = 1
            totPage = nil
            viewState = nil
        }
    }
}
