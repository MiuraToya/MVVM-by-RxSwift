//
//  GithubModel.swift
//  PracticeRx
//
//  Created by 三浦　登哉 on 2021/06/10.
//

import Foundation

struct Item: Codable {
    let items: [GithubModel]?
}

struct GithubModel: Codable {
    var id: Int
    var fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
    }
}

enum GithubError: Error {
    case networkError, unknownError
}
