//
//  Blocks.swift
//  NamadaExporer
//
//  Created by pnam on 05/02/2024.
//

import Foundation
import Alamofire

struct BlocksRequest: SupabaseRequest {
    typealias Response = Blocks
    
    var path: String = "blocks"
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

// MARK: - Block
struct Block: Codable, Hashable {
    let height: Int
    let hash: String
    let time: String
    let numTxs: Int
    let proposerAddress: String

    enum CodingKeys: String, CodingKey {
        case height, hash, time
        case numTxs = "num_txs"
        case proposerAddress = "proposer_address"
    }
}

typealias Blocks = [Block]
