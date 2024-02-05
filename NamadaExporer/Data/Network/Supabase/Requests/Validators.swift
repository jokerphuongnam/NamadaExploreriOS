//
//  Validators.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation
import Alamofire

final class ValidatorsRequest: SupabaseRequest {
    typealias Response = Validators
    
    var path: String = "validators"
    var parameters: Parameters
    
    init(select: String? = nil, order: SupabaseOrder.SortOrder, limit: Int) {
        parameters = [
            "select": select ?? "*",
            "order": SupabaseOrder(field: .votingPower, order: order).text,
            "limit": limit
        ]
    }
}

// MARK: - Validator
struct Validator: Codable, Hashable {
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

typealias Validators = [Validator]
