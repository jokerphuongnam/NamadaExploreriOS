//
//  TransactionsState.swift
//  NamadaExporer
//
//  Created by pnam on 08/02/2024.
//

import Foundation

enum TransactionsState: CaseIterable {
    case transfers
    case bonds
    
    var title: String {
        switch self {
        case .transfers:
            return "Transfers"
        case .bonds:
            return "Bonds"
        }
    }
}
