//
//  APIService.swift
//  searchapp
//
//  Created by talha on 18/11/2021.
//

import Foundation
import Moya
import Alamofire

protocol APISessionHandler{
    associatedtype Target: TargetType
    var provider : MoyaProvider<Target> { get }
    var defaultAlamofireSession : Session { get  }
}

extension APISessionHandler{
    var defaultAlamofireSession : Session{
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        return Session(configuration: configuration, startRequestsImmediately: false)
    }
    var provider : MoyaProvider<Target>{
        MoyaProvider<Target>(session : defaultAlamofireSession, plugins: [NetworkLoggerPlugin()])
    }
}

protocol APIRequestHandlerFunction : APISessionHandler {
    func fetchResult<T : Decodable>(target : Target,success : @escaping (T) ->(), failure : @escaping (APIRequestError) -> ())
}


struct APIRequest :  APIRequestHandlerFunction{
    
    private init(){}
    static let shared = APIRequest()
    var provider : MoyaProvider<Search>{
        MoyaProvider<Search>(session : defaultAlamofireSession, plugins: [NetworkLoggerPlugin()])
    }
    
    func fetchResult<T>(target: Search, success: @escaping (T) -> (), failure: @escaping (APIRequestError) -> ()) where T : Decodable {
        self.provider.request(target, completion: {
            result in
            
            
            switch result{
            case .success(let result):
                let reponseData =  result.data
                switch result.statusCode{
                case 200:
                    do{
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(T.self, from: reponseData)
                        success(model)
                    }catch let err{
                        print(err.localizedDescription)
                        failure(.Invalid_JSON("Invalid JSON"))
                    }
                    
                case 400...499:
                    do{
                        let decoder = JSONDecoder()
                        let model = try decoder.decode(FailureModel.self, from: reponseData)
                        failure(.Invalid_JSON(model.message))
                    }catch let err{
                        print(err.localizedDescription)
                        failure(.other("Something went wrong"))
                    }
                case 500...599:
                    print("Server error")
                    failure(.httpError("Internal Server Error"))
                default :
                    break
                }
            case .failure(_):
                failure(.other("Something went wrong"))
            }
        })
    }
}

enum APIRequestError: Error,Equatable {
    case httpError(String)
    case other(String)
    case Invalid_JSON(String)
    case Limit_Reaced(String)
    
}

