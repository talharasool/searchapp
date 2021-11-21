//
//  SearchAPI.swift
//  searchapp
//
//  Created by talha on 18/11/2021.
//

import Foundation
import Moya

enum Search  {
    case searchComponents(login : String, page :  UInt)
    
}

extension Search : TargetType{
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL : URL {
        return  URL(string: "https://api.github.com")!}
    
    var path: String {
        switch self {
        case .searchComponents:
            let searchURL = "/search/users"
            return searchURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchComponents:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {            
        case .searchComponents(let login, let page):
            return .requestParameters(
                parameters: [  "page": page, "per_page" : 9,"q": login], encoding: URLEncoding.queryString)
            
        }
    }
}


