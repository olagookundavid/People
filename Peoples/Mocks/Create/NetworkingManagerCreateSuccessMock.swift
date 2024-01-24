//
//  NetworkingManagerCreateSuccessMock.swift
//  Peoples
//
//  Created by David OH on 12/18/23.
//

#if DEBUG
import Foundation

class NetworkingManagerCreateSuccessMock: NetworkingManagerImpl {
    
    func request<T>(session: URLSession, endpoint: EndPoint, type: T.Type) async throws -> T where T : Decodable {
        return Data() as! T
    }
    
    func request(session: URLSession, endpoint: EndPoint) async throws {}
}
#endif
