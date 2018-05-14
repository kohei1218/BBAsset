//
//  Ticker.swift
//  MyBitChecker
//
//  Created by 齋藤　航平 on 2018/04/26.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import Foundation

struct Ticker: Codable {
    let success: Int
    let data: DataClass
}

struct DataClass: Codable {
    let sell, buy, high, low: String
    let last, vol: String
    let timestamp: Int
}
