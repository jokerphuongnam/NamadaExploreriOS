//
//  Blocks.swift
//  NamadaExporer
//
//  Created by pnam on 05/02/2024.
//

import Foundation
import Alamofire

final class BlocksRequest: SupabaseRequest {
    typealias Response = Blocks
    
    var path: String = "blocks"
    var parameters: Parameters
    
    init(selects: [SupabaseSelect], order: SupabaseOrder.SortOrder, limit: Int) {
        parameters = [
            "select": selects.createQueryString(),
            "order": SupabaseOrder(field: .height, order: order).text,
            "limit": limit
        ]
    }
}

// MARK: - Block
private let dateFormatter = DateFormatter()
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
    
    var date: Date {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return dateFormatter.date(from: time)!
    }
}

typealias Blocks = [Block]
