//
//  Validators.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation
import Alamofire

struct ValidatorsRequest<Response>: SupabaseRequest where Response: Validators {
    var path: String = "validators"
    var parameters: Parameters
    
    init(selects: [SupabaseSelect], orders: [SupabaseOrder], limit: Int?, offset: Int?) {
        parameters = [
            "select": selects.createQueryString()
        ]
        if !orders.isEmpty {
            parameters["order"] =  orders.createQueryString()
        }
        if let offset = offset {
            parameters["offset"] =  offset
        }
        if let limit = limit {
            parameters["limit"] =  limit
        }
    }
}

// MARK: - Validator
protocol Validator: Codable & Equatable {
    typealias AllField = ValidatorAllFields
    typealias VotingPower = ValidatorVotingPower
}

protocol Validators: Codable & Equatable {
    typealias AllField = [Validator.AllField]
    typealias VotingPower = [Validator.VotingPower]
}

extension Array: Validators where Element: Validator { }

struct ValidatorAllFields: Validator, Codable, Hashable  {
    let height: Int
    let name: String?
    let address: String
    let votingPower: Int
    let pubKey: String
    let proposerPriority: Int

    enum CodingKeys: String, CodingKey {
        case height, name, address
        case votingPower = "voting_power"
        case pubKey = "pub_key"
        case proposerPriority = "proposer_priority"
    }
}

struct ValidatorVotingPower: Validator, Codable, Hashable  {
    let votingPower: Int
    
    enum CodingKeys: String, CodingKey {
        case votingPower = "voting_power"
    }
}
