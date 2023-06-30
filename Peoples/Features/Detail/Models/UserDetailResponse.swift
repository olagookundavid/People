//
//  UserDetailResponse.swift
//  Peoples
//
//  Created by David OH on 23/06/2023.
//

// MARK: - UserDetailResponse
struct UserDetailResponse: Codable, Equatable {
    let data: User
    let support: Support
}
