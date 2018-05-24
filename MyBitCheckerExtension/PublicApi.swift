//
//  BbApi.swift
//  MyBitChecker
//
//  Created by 齋藤　航平 on 2018/04/26.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import Foundation
import Moya

enum PublicApi {
    case getTicker(pair: String)
}

extension PublicApi: TargetType {
    var headers: [String : String]? {
        return ["Content-Type":"application/json"]
    }
    
    var baseURL: URL {
        return URL(string: "https://public.bitbank.cc")!
    }
    
    var path: String {
        switch self {
        case .getTicker(let pair):
            return "/\(pair)/ticker"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTicker:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getTicker(let pair):
            return .requestPlain
        }
    }
    
    
}
