//
//  PrivateApi.swift
//  MyBitChecker
//
//  Created by 齋藤　航平 on 2018/05/15.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import Foundation
import Moya
import CryptoSwift

enum PrivateApi {
    case getAssets()
}

extension PrivateApi: TargetType {
    var headers: [String : String]? {
        return [
            "Content-Type":"application/json",
            "ACCESS-KEY" : "api key",
            "ACCESS-NONCE" : self.makeHaederUnixTime(unixTime: String(floor(NSDate().timeIntervalSince1970) * 1000)),
            "ACCESS-SIGNATURE" : self.makeAccessSignWith(accessKey: "api secret", unixtime: String(floor(NSDate().timeIntervalSince1970) * 1000), path: "/v1/user/assets", queryParam: "")!
        ]
    }
    
    var baseURL: URL {
        return URL(string: "https://api.bitbank.cc/v1")!
    }
    
    var path: String {
        switch self {
        case .getAssets():
            return "/user/assets"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAssets():
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getAssets():
            return .requestPlain
        }
    }
    
    private func makeAccessSignWith(accessKey: String, unixtime: String, path: String, queryParam: String) -> String? {
        let unixTimeStr = self.makeHaederUnixTime(unixTime: unixtime)
        let linkedStr = unixTimeStr + path + queryParam
        
        var bytes: [UInt8] = []
        
        bytes += linkedStr.bytes
        
        let signedString = try? HMAC(key: "api secret", variant: .sha256).authenticate(bytes)
        
        return signedString?.toHexString()
    }
    
    private func makeHaederUnixTime(unixTime: String) -> String {
        return unixTime.replacingOccurrences(of: ".0", with: "")
    }
    
}
