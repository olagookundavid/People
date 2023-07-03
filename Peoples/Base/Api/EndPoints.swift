//
//  EndPoints.swift
//  Peoples
//
//  Created by David OH on 03/07/2023.
//

import Foundation
enum EndPoint{
    case create(submissionData: Data?), detail(id: Int), people
}


extension EndPoint{
    var host: String{"reqres.in"}
    var path: String{
        switch self{
        case .people,
            .create:
            return "/api/users"
        case .detail(id: let id):
            return "/api/users/\(id)"
        }}
    enum MethodType{
        
        case get
        case post(data: Data?)
        case put(data: Data?)
        case delete(data: Data?)
    }
    
    var methodType: MethodType{
        switch self {
        case .people,
             .detail:
            return .get
        case .create(let data):
            return .post(data: data)
        }
    }
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
#if DEBUG
        urlComponents.queryItems = [
            URLQueryItem(name: "delay", value: "3")
        ]
#endif
        return urlComponents.url
        
        
    }
}
