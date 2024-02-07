//
//  GenesisAccounts.swift
//  NamadaExporer
//
//  Created by P. Nam on 07/02/2024.
//

import Foundation

struct GenesisAccountsRequest: NamadaInfoRequest {
    typealias Response = GenesisAccounts
    
    var path: String = "shielded-expedition.88f17d1d14/output/genesis_accounts_min.json"
}

// MARK: - GenesisAccount
struct GenesisAccount: Codable, Hashable {
    let consensusKeyPk: String
    let hashedKey: String
    let address: String
    let commissionRate: String
    let maxCommissionRateChange: String
    let alias: String
    let netAddress: String
    let bondAmount: String

    enum CodingKeys: String, CodingKey {
        case consensusKeyPk = "consensus_key_pk"
        case hashedKey = "hashed_key"
        case address
        case commissionRate = "commission_rate"
        case maxCommissionRateChange = "max_commission_rate_change"
        case alias
        case netAddress = "net_address"
        case bondAmount = "bond_amount"
    }
}


typealias GenesisAccounts = [GenesisAccount]
