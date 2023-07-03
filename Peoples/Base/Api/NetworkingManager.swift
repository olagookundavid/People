//
//  NetworkingManager.swift
//  Peoples
//
//  Created by David OH on 30/06/2023.
//

import Foundation

class NetworkingManager {
    
    static let shared = NetworkingManager()
    private init(){
        
    }
    func request<T: Codable>(endpoint: EndPoint, type: T.Type,
                             completion: @escaping ((Result<T, Error>) -> Void)
    ){
    
        guard let url = endpoint.url else{
            completion(.failure(NetworkingError.invalidUrl))
            return
        }
        
        
        let request = buildRequest(url: url, methodtype: endpoint.methodType)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(NetworkingError.custom(error: error!)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
                completion(.failure(NetworkingError.invalidStatusCode(statusCode: (response as! HTTPURLResponse).statusCode )))
                return
            }
             
            guard let data = data else {
                completion(.failure(NetworkingError.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let res = try decoder.decode(T.self , from: data)
                completion(.success(res))
            }
            catch {
                completion(.failure(NetworkingError.failedToDecode(error: error)))
            }
            
        }
        dataTask.resume()
    }
    
    
    func request(endpoint: EndPoint,
                             completion: @escaping ((Result<(), Error>) -> Void)
    ){
    
        guard let url = endpoint.url else{
            completion(.failure(NetworkingError.invalidUrl))
            return
        }
        
        
        let request = buildRequest(url: url, methodtype: endpoint.methodType)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(NetworkingError.custom(error: error!)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
                completion(.failure(NetworkingError.invalidStatusCode(statusCode: (response as! HTTPURLResponse).statusCode )))
                return
            }
            completion(.success(()))
            
        }
        dataTask.resume()
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
    
//    enum methodType{
//        case get
//        case post(data: Data?)
//        case put(data: Data?)
//        case delete(data: Data?)
//    }
    
    
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
