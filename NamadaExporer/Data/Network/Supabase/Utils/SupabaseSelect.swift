//
//  SupabaseSelect.swift
//  NamadaExporer
//
//  Created by pnam on 05/02/2024.
//

import Foundation

enum SupabaseSelect: String, CaseIterable {
    case height = "height"
    case hash = "hash"
    case time = "time"
    case numTxs = "num_txs"
    case proposerAddress = "proposer_address"
    case votingPower = "voting_power"
}

extension Array where Element == SupabaseSelect {
    func createQueryString() -> String {
        if isEmpty { return  "*" }
        let propertyNames = self.map { $0.rawValue }
        let encodedProperties = propertyNames.map { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0 }
        return encodedProperties.joined(separator: "%2C").removingPercentEncoding!
    }
    
    static var all: Self {
        []
    }
}
