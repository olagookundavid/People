//
//  NetworkingManagerUserDetailsResponseFailureMock.swift
//  Peoples
//
//  Created by David OH on 12/18/23.
//

#if DEBUG
import Foundation

class NetworkingManagerUserDetailsResponseFailureMock: NetworkingManagerImpl {

    func request<T>(session: URLSession, endpoint: EndPoint, type: T.Type) async throws -> T where T : Decodable {
        throw NetworkingManager.NetworkingError.invalidUrl
    }

    func request(session: URLSession, endpoint: EndPoint) async throws {}
}
#endif
