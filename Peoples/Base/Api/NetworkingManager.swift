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
    func request<T: Codable>(absUrl:String, type: T.Type,
                             completion: @escaping ((Result<T, Error>) -> Void)
    ){
    
        guard let url = URL(string: absUrl) else{
            completion(.failure(NetworkingError.invalidUrl))
            return
        }
        
        
        let request = URLRequest(url: url)
        
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
   
}


extension NetworkingManager {
    enum NetworkingError: Error{
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error : Error)
    }
}