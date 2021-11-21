//
//  Model.swift
//  searchapp
//
//  Created by talha on 20/11/2021.
//

import Foundation


struct FailureModel : Decodable{
    
    let documentation_url : String
    let message : String
    enum CodingKeys : String , CodingKey{
        case documentation_url = "documentation_url"
        case message
    }
    
    
}

struct SearchModel : Decodable{
    
    let total_count : Int
    let incomplete_results: Bool
    let items : [SearchData]
    
    enum CodingKeys : String , CodingKey{
        case total_count
        case incomplete_results
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total_count = try container.decodeIfPresent(Int.self, forKey: .total_count) ?? Int()
        incomplete_results = try container.decodeIfPresent(Bool.self, forKey: .incomplete_results) ?? Bool()
        items = try container.decodeIfPresent([SearchData].self, forKey: .items)?.sorted(by: { $0 < $1 }) ?? []
    }
    
}

struct SearchData : Decodable,Comparable{
    
    let type : String
    let login : String
    let avatar_url : String
    
    enum CodingKeys : String , CodingKey{
        case avatar_url
        case login
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatar_url = try container.decodeIfPresent(String.self, forKey: .avatar_url) ?? String()
        login = try container.decodeIfPresent(String.self, forKey: .login) ?? String()
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? String()
    }
    
    static func <(lhs: SearchData, rhs: SearchData) -> Bool {
        return lhs.login.lowercased() < rhs.login.lowercased()
    }
    
}
