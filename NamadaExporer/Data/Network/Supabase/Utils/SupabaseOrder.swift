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
        self.text = "\(field.rawValue).\(order.rawValue)"
    }
    
    enum SortField: String {
        case votingPower = "voting_power"
        case height = "height"
    }
    enum SortOrder: String {
        case desc = "desc"
        case asc = "asc"
    }
}

extension Array where Element == SupabaseOrder {
    func createQueryString() -> String {
        if isEmpty { return  "*" }
        let propertyNames = self.map { $0.text }
        let encodedProperties = propertyNames.map { $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0 }
        return encodedProperties.joined(separator: "%2C").removingPercentEncoding!
    }
}
