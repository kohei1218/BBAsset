//
//  Asset.swift
//  MyBitCheckerExtension
//
//  Created by 齋藤　航平 on 2018/05/17.
//  Copyright © 2018年 齋藤　航平. All rights reserved.
//

import Foundation

struct Asset: Codable {
    let success: Int
    let data: AssetDataClass
}

struct AssetDataClass: Codable {
    let assets: [AssetElement]
}

struct AssetElement: Codable {
    let asset: String
    let amountPrecision: Int
    let onhandAmount, lockedAmount, freeAmount: String
    let stopDeposit, stopWithdrawal: Bool
    let withdrawalFee: WithdrawalFeeUnion
    
    enum CodingKeys: String, CodingKey {
        case asset
        case amountPrecision = "amount_precision"
        case onhandAmount = "onhand_amount"
        case lockedAmount = "locked_amount"
        case freeAmount = "free_amount"
        case stopDeposit = "stop_deposit"
        case stopWithdrawal = "stop_withdrawal"
        case withdrawalFee = "withdrawal_fee"
    }
}

enum WithdrawalFeeUnion: Codable {
    case string(String)
    case withdrawalFeeClass(WithdrawalFeeClass)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(WithdrawalFeeClass.self) {
            self = .withdrawalFeeClass(x)
            return
        }
        throw DecodingError.typeMismatch(WithdrawalFeeUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for WithdrawalFeeUnion"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .withdrawalFeeClass(let x):
            try container.encode(x)
        }
    }
}

struct WithdrawalFeeClass: Codable {
    let threshold, under, over: String
}
