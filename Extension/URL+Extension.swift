//
//  URL+Extension.swift
//  Weike
//
//  Created by yake on 2017/2/7.
//  Copyright © 2017年 Kuaizai. All rights reserved.
//

import Foundation

extension URL {
    var queryDictionary: [String: String]? {
        guard let queryString = query else { return nil }
        var dictionary: [String: String] = [:]
        
        let queryComponents = queryString.components(separatedBy: "&")
        for queryItemString in queryComponents {
            let items = queryItemString.components(separatedBy: "=")
            guard items.count == 2 else { continue }
            let name = items[0]
            let value = items[1]
            dictionary[name] = value.removingPercentEncoding
        }
        return dictionary
    }
    
    func getQueryValue(for name: String) -> String? {
        guard let dictionary = queryDictionary else { return nil }
        return dictionary[name]
    }
}
