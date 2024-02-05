//
//  SupabaseOrder.swift
//  NamadaExporer
//
//  Created by pnam on 04/02/2024.
//

import Foundation

struct SupabaseOrder {
    let text: String
    
    init(field: SortField, order: SortOrder) {
        self.text = "\(field.text).\(order.text)"
    }
    
    enum SortField {
        case votingPower
        
        var text: String {
            switch self {
            case .votingPower:
                return "voting_power"
            }
        }
    }
    enum SortOrder {
        case desc
        case asc
        
        var text: String {
            switch self {
            case .desc:
                return "desc"
            case .asc:
                return "asc"
            }
        }
    }
}
