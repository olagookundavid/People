//
//  UsersResponse.swift
//  Peoples
//
//  Created by David OH on 23/06/2023.
//
// MARK: - UsersResponse
struct UsersResponse: Codable, Equatable {
    let page, perPage, total, totalPages: Int
    let data: [User]
    let support: Support
}
