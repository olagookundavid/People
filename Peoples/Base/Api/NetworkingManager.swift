//
//  NetworkingManager.swift
//  Peoples
//
//  Created by David OH on 30/06/2023.
//

import Foundation

protocol NetworkingManagerImpl {
    
    func request<T: Codable>(session: URLSession,
                              endpoint: EndPoint,
                             type: T.Type) async throws -> T
    
    func request(session: URLSession,
                 endpoint: EndPoint) async throws
}

final class NetworkingManager: NetworkingManagerImpl {
    
    static let shared = NetworkingManager()
    private init(){
        
    }
    func request<T: Codable>(session: URLSession = .shared, endpoint: EndPoint, type: T.Type) async throws  -> T{
    
        guard let url = endpoint.url else{
            throw NetworkingError.invalidUrl
        }
        
        
        let request = buildRequest(url: url, methodtype: endpoint.methodType)
        
        let (data, response) = try await session.data(for: request)
        
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode )
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let res = try decoder.decode(T.self , from: data)
        return res
    }
    
    
    func request(session: URLSession = .shared, endpoint: EndPoint) async throws {

        guard let url = endpoint.url else{
            throw NetworkingError.invalidUrl
        }


        let request = buildRequest(url: url, methodtype: endpoint.methodType)

        let (_, response) = try await session.data(for: request)


        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkingError.invalidStatusCode(statusCode: statusCode )
        }
    }
   
}


extension NetworkingManager {
    enum NetworkingError: LocalizedError{
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error : Error)
        
        var errorDescription: String?{
            switch self{
                
            case .invalidUrl:
                return "Url not valid"
            case .invalidStatusCode:
                return  "Invalid status code"
            case .invalidData:
                return  "Response data is invalid"
            case .failedToDecode:
                return "Failed to decode response"
            case .custom(error: let error):
                return "Something went wrong \(error.localizedDescription)"
            }
        }
    }
    
    
    func buildRequest (url: URL, methodtype: EndPoint.MethodType) -> URLRequest{
        var request = URLRequest(url: url)
        switch methodtype{
        case .get:
            request.httpMethod = "Get"
        case .post(let data):
            request.httpMethod = "POST"
            request.httpBody = data
        case .put(let data):
            request.httpMethod = "PUT"
            request.httpBody = data
        case .delete(let data):
            request.httpMethod = "DELETE"
            request.httpBody = data
        }
        return request
    }
}

extension NetworkingManager.NetworkingError: Equatable {
    
    static func == (lhs: NetworkingManager.NetworkingError, rhs: NetworkingManager.NetworkingError) -> Bool {
        switch(lhs, rhs) {
        case (.invalidUrl, .invalidUrl):
            return true
        case (.custom(let lhsType), .custom(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        case (.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
            return lhsType == rhsType
        case (.invalidData, .invalidData):
            return true
        case (.failedToDecode(let lhsType), .failedToDecode(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}
