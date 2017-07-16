//
//  Router.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/10.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import Alamofire

func buildURLRequest(_ result: (method: Alamofire.HTTPMethod, path: String, parameters: Parameters)) throws -> URLRequest {
    let url = URL(string: Config.Http.baseURL)!
    var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
    urlRequest.httpMethod = result.method.rawValue
    let request = try URLEncoding.default.encode(urlRequest, with: result.parameters)
    printLog(request)
    return request
}


struct Router {
    
    enum Chartlet: URLRequestConvertible {
        
        case getChartletList
        
        func asURLRequest() throws -> URLRequest {
            let result: (Alamofire.HTTPMethod, String, Parameters) = {
                switch self {
                case .getChartletList:
                    let parameters: Parameters = [
                        "data_type": 1,
                        "all": 1
                    ]
                    return (.get, "/api/v1/backgrounds", parameters)
                }
            }()
            
            return try buildURLRequest(result)
        }
    }
    
    
    
    enum Camera: URLRequestConvertible {
        
        case getBackgroundPosterList
        
        func asURLRequest() throws -> URLRequest {
            let result: (Alamofire.HTTPMethod, String, Parameters) = {
                switch self {
                case .getBackgroundPosterList:
                    let parameters: Parameters = [
                        "data_type": 0,
                        "all": 1
                    ]
                    return (.get, "/api/v1/backgrounds", parameters)
                }
            }()
            
            return try buildURLRequest(result)
        }
    }
    
    enum Audio: URLRequestConvertible {
        
        case getOnlineAudios
        
        func asURLRequest() throws -> URLRequest {
            let result: (Alamofire.HTTPMethod, String, Parameters) = {
                switch self {
                case .getOnlineAudios:
                    let parameters: Parameters = [
                        "per": 20,
                        "page": 1,
                        "all": 1
                    ]
                    return (.get, "/api/v1/audios", parameters)
                }
            }()
            
            return try buildURLRequest(result)
        }
    }
}

