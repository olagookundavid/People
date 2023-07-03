//
//  EndPoints.swift
//  Peoples
//
//  Created by David OH on 03/07/2023.
//

import Foundation
enum EndPoint{
    case create, detail(id: Int), people
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
        case Get
        case POST(data: Data?)
    }
}
